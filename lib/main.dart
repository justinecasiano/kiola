import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_management_system/src/screens/home_screen.dart';
import 'package:learning_management_system/src/screens/splash_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kiola',
      initialRoute: '/home',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen()
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}
