import 'package:flutter/material.dart';
import 'package:learning_management_system/src/screens/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () => showModalBottomSheet(
                context: (context),
                builder: (context) => const RegisterScreen(),
              ),
          child: const Text('Register')),
    );
  }
}
