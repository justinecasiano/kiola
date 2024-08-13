import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/student.dart';
import '/src/models/cubits/student_cubit.dart';
import '../extras/utils.dart';
import '../models/cubits/navigation_cubit.dart';
import '../models/quiz_summary.dart';
import 'dashboard_screen.dart';
import 'lesson_screen.dart';
import 'settings_screen.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;
import '../constants/icons.dart' as icons;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int backClicks = 0;
  bool canPop = false;

  final List<NavigationDestination> destinations =
      ['dashboard', 'lesson', 'settings']
          .map((icon) => NavigationDestination(
                label: '',
                icon: icons.getIcon(icon),
                selectedIcon: icons.getIcon(icon, selected: true),
              ))
          .toList();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      DashboardScreen(),
      LessonScreen(),
      SettingsScreen(),
    ];

    return PopScope(
      canPop: canPop,
      onPopInvoked: (shouldPop) {
        if (context.read<StudentCubit>().state.getLessonQuizSummary().status !=
            'active') {
          if (context.read<NavigationCubit>().state != 0) {
            context.read<NavigationCubit>().updateIndex(0);
          } else {
            if (backClicks == 0) {
              Utils.showToastMessage('Press back again to exit');
              setState(() => canPop = true);
            } else {
              setState(() => backClicks--);
            }
          }
        } else {
          Utils.showToastMessage('Quiz is active');
        }
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: colors.primaryShade,
          bottomNavigationBar: CustomNavigationBar(destinations: destinations),
          body: SizedBox(
            height: Utils.appGetHeight(context, 93),
            child: BlocBuilder<NavigationCubit, int>(
              builder: (BuildContext context, int index) => screens[index],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final List<NavigationDestination> destinations;

  const CustomNavigationBar({super.key, required this.destinations});

  Function(int) onDestinationSelected(BuildContext context) {
    return ((int index) {
      QuizSummary quiz =
          context.read<StudentCubit>().state.getLessonQuizSummary();

      if (quiz.status == 'active') {
        Utils.showToastMessage('Quiz is active');
        return;
      }
      context.read<NavigationCubit>().updateIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(values.medium),
          child: NavigationBar(
            height: Utils.appGetHeight(context, 7),
            backgroundColor: colors.accentDark,
            animationDuration: const Duration(milliseconds: 1000),
            indicatorShape: null,
            indicatorColor: Colors.transparent,
            destinations: destinations,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: context.watch<NavigationCubit>().state,
            onDestinationSelected: onDestinationSelected(context),
          ),
        ),
      ),
    );
  }
}
