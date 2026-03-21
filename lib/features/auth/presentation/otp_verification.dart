import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String contactInfo; // To display where the OTP was sent

  const OtpVerificationScreen({
    super.key,
    this.contactInfo = "+91 9876543210", // Example placeholder
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Controllers for 4-digit OTP
  final TextEditingController _otp1 = TextEditingController();
  final TextEditingController _otp2 = TextEditingController();
  final TextEditingController _otp3 = TextEditingController();
  final TextEditingController _otp4 = TextEditingController();

  // Focus nodes to auto-shift to the next box
  final FocusNode _focus1 = FocusNode();
  final FocusNode _focus2 = FocusNode();
  final FocusNode _focus3 = FocusNode();
  final FocusNode _focus4 = FocusNode();

  @override
  void dispose() {
    _otp1.dispose();
    _otp2.dispose();
    _otp3.dispose();
    _otp4.dispose();
    _focus1.dispose();
    _focus2.dispose();
    _focus3.dispose();
    _focus4.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    String otpCode = _otp1.text + _otp2.text + _otp3.text + _otp4.text;

    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit OTP.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // TODO: Implement your OTP verification logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verifying OTP: $otpCode...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500), // Responsive constraint
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Icon
                const Center(
                  child: Icon(
                    Icons.security_rounded, // Shield/Security icon for OTP
                    size: 80,
                    color: Color(0xFF2962FF),
                  ),
                ),
                const SizedBox(height: 24),

                // Title & Subtitle
                const Text(
                  'Verification Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'We have sent the verification code to\n',
                    style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                    children: [
                      TextSpan(
                        text: widget.contactInfo,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // OTP Input Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpBox(context, _otp1, _focus1, _focus2),
                    _buildOtpBox(context, _otp2, _focus2, _focus3),
                    _buildOtpBox(context, _otp3, _focus3, _focus4),
                    _buildOtpBox(context, _otp4, _focus4, null),
                  ],
                ),
                const SizedBox(height: 40),

                // Verify Button
                ElevatedButton(
                  onPressed: _verifyOtp,
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
                    'Verify & Proceed',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                // Resend Text
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive the code? ",
                      style: const TextStyle(color: Colors.black87, fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          // Optional: Add TapGestureRecognizer here to handle resend
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Optional: Resend Timer Placeholder
                const Center(
                  child: Text(
                    '00:30', // You can replace this with a dynamic timer
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build individual OTP boxes
  Widget _buildOtpBox(
      BuildContext context,
      TextEditingController controller,
      FocusNode currentFocus,
      FocusNode? nextFocus,
      ) {
    return SizedBox(
      width: 65,
      height: 65,
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1), // Only 1 digit per box
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          // Auto-shift to the next box when a digit is entered
          if (value.isNotEmpty && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
          // Optional: Auto-shift back when deleted (requires more complex logic or RawKeyboardListener)
        },
        decoration: InputDecoration(
          counterText: "", // Hides length counter
          contentPadding: EdgeInsets.zero, // Centers text vertically
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black38),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF2962FF), width: 2),
          ),
        ),
      ),
    );
  }
}