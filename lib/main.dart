import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/src/models/cubits/navigation_cubit.dart';
import 'src/extras/utils.dart';
import 'src/models/cubits/lesson_cubit.dart';
import 'src/models/cubits/student_cubit.dart';
import 'src/models/lesson.dart';
import 'src/models/student.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/splash_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Lesson> lessons = [];
  Student? student;

  Future<int?> initialize(BuildContext context) async {
    try {
      List result = await Future.wait([
        Utils.loadJson(context, 'assets/lessons.json'),
        Utils.loadJson(context, 'assets/student.json')
      ]);

      lessons = (result[0] as List<dynamic>)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList();
      student = Student.fromJson(result[1]);
    } catch (e) {
      print(e);
    }
    return lessons.isEmpty || student == null ? null : 1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kiola',
      home: FutureBuilder(
          future: initialize(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('lesson and user data are successfully loaded');

              return MultiBlocProvider(providers: [
                BlocProvider(create: (_) => NavigationCubit()),
                BlocProvider(create: (_) => LessonCubit(lessons: lessons)),
                BlocProvider(create: (_) => StudentCubit(student!)),
              ], child: const HomeScreen());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 12),
              ));
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
      routes: {
        '/splash': (context) => const SplashScreen(),
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}
