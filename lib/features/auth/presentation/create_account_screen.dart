import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for inputFormatters

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // 1. Add a FormKey for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isAgreed = false;
  bool _isEmailMode = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              // 2. Wrap the Column in a Form widget
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Skip Button
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
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

                    // Logo Icon
                    const Center(
                      child: Icon(
                        Icons.person_add_alt_1,
                        size: 80,
                        color: Color(0xFF2962FF),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title & Subtitle
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Register with OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Input Fields
                    _buildCustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Full Name',
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.name,
                      // Validate Name
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Dynamic Contact Field
                    _buildCustomTextField(
                      controller: _contactController,
                      label: 'Contact Access',
                      hint: _isEmailMode ? 'Email Address' : 'Phone Number',
                      prefixIcon: _isEmailMode ? Icons.email : Icons.phone,
                      keyboardType: _isEmailMode ? TextInputType.emailAddress : TextInputType.phone,

                      // Restrict phone number to 10 digits strictly via keyboard formatter
                      maxLength: _isEmailMode ? null : 10,
                      inputFormatters: _isEmailMode
                          ? [] // No restrictions for email typing
                          : [FilteringTextInputFormatter.digitsOnly], // Only numbers for phone

                      // Validate Email or Phone
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return _isEmailMode
                              ? 'Please enter your email address'
                              : 'Please enter your phone number';
                        }

                        if (_isEmailMode) {
                          // Email Regex Validation
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                        } else {
                          // Phone Length Validation
                          if (value.length < 10) {
                            return 'Phone number must be exactly 10 digits';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Privacy Policy Checkbox
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _isAgreed,
                            activeColor: const Color(0xFF2962FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isAgreed = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(color: Colors.black87, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xFF1565C0),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 29),

                    // Or Divider
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

                    // Dynamic Toggle Button
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isEmailMode = !_isEmailMode;
                                _contactController.clear();
                                // Reset validation errors when switching modes
                                _formKey.currentState?.reset();
                              });
                            },
                            icon: Icon(
                                _isEmailMode ? Icons.phone : Icons.email,
                                color: Colors.black87
                            ),
                            label: Text(
                              _isEmailMode ? 'Phone Number' : 'Email',
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
                        // 3. Trigger Form Validation
                        if (_formKey.currentState!.validate()) {
                          // Check if privacy policy is checked
                          if (!_isAgreed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please agree to the Privacy Policy.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          // If everything is valid, proceed
                          String name = _nameController.text;
                          String contactInfo = _contactController.text;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sending OTP to $contactInfo...'),
                              backgroundColor: Colors.green,
                            ),
                          );
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

                    // Login Link
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Footer Terms
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'By signing in or creating an account, you agree with our ',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Terms Of Use',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Updated helper widget
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
        counterText: "", // Hides the "0/10" character counter below the field
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
        // Added Error Borders so validation highlights correctly in red
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