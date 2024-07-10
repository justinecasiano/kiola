import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/src/models/navigation_cubit.dart';
import 'src/models/content_cubit.dart';
import 'src/models/lesson_cubit.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/splash_screen.dart';

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
        '/home': (context) => MultiBlocProvider(providers: [
              BlocProvider(create: (_) => NavigationCubit()),
              BlocProvider(create: (_) => LessonCubit()),
              BlocProvider(create: (_) => ContentCubit()),
            ], child: const HomeScreen())
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}
