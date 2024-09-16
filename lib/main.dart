import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kiola/src/screens/introduction_screen.dart';
import 'package:kiola/src/screens/loading_screen.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/extras/utils.dart';
import 'src/models/cubits/lesson_cubit.dart';
import 'src/models/cubits/navigation_cubit.dart';
import 'src/models/cubits/student_cubit.dart';
import 'src/models/lesson.dart';
import 'src/models/student.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Lesson> lessons = [];
  Student? student;
  dynamic listener;

  Future<int?> initialize(BuildContext context) async {
    try {
      List result = await Future.wait([
        Utils.loadJsonFromAsset(context, 'assets/lessons.json'),
        Utils.loadStudentData(context, 'assets/student.json'),
      ]);

      lessons = (result[0] as List<dynamic>)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList();
      student = Student.fromJson(result[1]);
    } catch (e) {
      print(e);
    }
    await Future.delayed(1.seconds);
    return lessons.isEmpty || student == null ? null : 1;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('lessons and user data are successfully loaded');
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => NavigationCubit()),
              BlocProvider(create: (_) => LessonCubit(lessons: lessons)),
              BlocProvider(create: (_) => StudentCubit(student!)..setUuid()),
            ],
            child: BlocListener<StudentCubit, Student>(
              listener: (context, student) {
                Utils.updateLocalStudentData(student);
                if (student.shouldUpdate)
                  Utils.updateRemoteStudentData(context, student);
              },
              child: Kiola(),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoadingScreen(),
        );
      },
    );
  }
}

class Kiola extends StatelessWidget {
  late dynamic listener;
  Kiola({super.key});

  void registerConnectionListener(BuildContext context) {
    listener = InternetConnection().onStatusChange.listen(
      (status) {
        Student student = context.read<StudentCubit>().state;
        if (status == InternetStatus.connected && student.shouldUpdate)
          Utils.updateRemoteStudentData(context, student);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    registerConnectionListener(context);
    return RestorationScope(
      restorationId: 'root',
      child: MaterialApp(
        title: 'Kiola',
        theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreen(),
          '/intro': (context) => const IntroductionScreen(),
          '/home': (context) => const HomeScreen(),
        },
        initialRoute: context.read<StudentCubit>().state.username == null
            ? '/'
            : '/home',
      ),
    );
  }
}
