import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'create_account_screen.dart';
import 'otp_verification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();

  // Defaulting to Email mode to match your screenshot
  bool _isEmailMode = true;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Skip Button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle skip action
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // User Profile Icon (Using image asset as requested previously)
                  Center(
                    child: ClipOval(
                      child:  Image.asset(
                      'assets/icons/app_icon.png',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain, // Ensures the image scales correctly within the 80x80 box
                    )
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login with OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Dynamic Contact Field (Email or Phone)
                  _buildCustomTextField(
                    controller: _contactController,
                    label: _isEmailMode ? 'Email Address' : 'Phone Number',
                    hint: _isEmailMode ? 'Enter your email' : 'Enter your phone number',
                    prefixIcon: _isEmailMode ? Icons.email : Icons.phone,
                    keyboardType: _isEmailMode ? TextInputType.emailAddress : TextInputType.phone,

                    // Restrict phone number to 10 digits strictly via keyboard formatter
                    maxLength: _isEmailMode ? null : 10,
                    inputFormatters: _isEmailMode
                        ? []
                        : [FilteringTextInputFormatter.digitsOnly],

                    // Validation logic
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _isEmailMode
                            ? 'Please enter your email address'
                            : 'Please enter your phone number';
                      }

                      if (_isEmailMode) {
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      } else {
                        if (value.length < 10) {
                          return 'Phone number must be exactly 10 digits';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.black26, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.black26, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Dynamic Toggle Button to switch between Phone/Email
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isEmailMode = !_isEmailMode;
                              _contactController.clear();
                              _formKey.currentState?.reset(); // Clear validation errors
                            });
                          },
                          icon: Icon(
                              _isEmailMode ? Icons.phone : Icons.email,
                              color: Colors.black87
                          ),
                          label: Text(
                            _isEmailMode ? 'Login with Phone Number' : 'Login with Email',
                            style: const TextStyle(color: Colors.black87, fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.black38),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Send OTP Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String contactInfo = _contactController.text;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sending OTP to $contactInfo...'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpVerificationScreen(
                              contactInfo: contactInfo, // Passing the email or phone number here
                            ),
                          ),
                        );
                        // TODO: Navigate to OTP Verification Screen
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2962FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Create Account Link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Handle navigation to Create Account screen
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.black87, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Create Account',
                              style: const TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CreateAccountScreen(),
                                    ),
                                  );
                                },
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable helper widget mirroring the CreateAccount design perfectly
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
      decoration: InputDecoration(
        counterText: "", // Hides the character counter
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        prefixIcon: Icon(prefixIcon, color: Colors.black87),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black87),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2962FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}