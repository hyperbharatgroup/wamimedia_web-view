import 'package:flutter/material.dart';
import '../core/services/local_storage_service.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/auth/login_screen.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  Future<bool> _check() async {
    return await LocalStorageService.isOnboardingSeen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _check(),
      builder: (context, snapshot) {
        /// Loading state
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// if new onboarding screen or login screen
        if (snapshot.data == false) {
          return const LoginScreen();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}