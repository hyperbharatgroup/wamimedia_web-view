import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/local_storage_service.dart';
import '../data/onboarding_data.dart';
import '../../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  Future<void> _finish() async {
    await LocalStorageService.setOnboardingSeen();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _next() {
    if (_index == onboardingData.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Skip
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text("Skip"),
              ),
            ),

            /// Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final item = onboardingData[i];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Lottie
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            key: ValueKey(item.lottie),
                            height: size.height * 0.35,
                            child: Lottie.asset(item.lottie),
                          ),
                        ),

                        SizedBox(height: size.height * 0.001),

                        /// Title
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 400),
                          opacity: _index == i ? 1 : 0,
                          child: Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width * 0.065,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.02),

                        /// Subtitle
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: _index == i ? 1 : 0,
                          child: Text(
                            item.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: onboardingData.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.deepPurple,
              ),
            ),

            SizedBox(height: size.height * 0.03),

            /// Button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08),
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                  Size(double.infinity, size.height * 0.06),
                ),
                child: Text(
                  _index == onboardingData.length - 1
                      ? "Get Started"
                      : "Next",
                ),
              ),
            ),

            SizedBox(height: size.height * 0.09),
          ],
        ),
      ),
    );
  }
}