import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../extras/utils.dart';
import '../models/cubits/lesson_cubit.dart';
import '../models/cubits/navigation_cubit.dart';
import '../models/lesson.dart';
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
  List<NavigationDestination> destinations = ['dashboard', 'lesson', 'settings']
      .map<NavigationDestination>((icon) => NavigationDestination(
            label: '',
            icon: icons.getIcon(icon),
            selectedIcon: icons.getIcon(icon, selected: true),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocBuilder<NavigationCubit, int>(
        builder: (BuildContext context, int state) {
      return Scaffold(
        backgroundColor: colors.primaryShade,
        body: IndexedStack(index: state, children: [
          const DashboardScreen(),
          BlocBuilder<LessonCubit, Lesson>(
            builder: (BuildContext context, Lesson state) {
              return const LessonScreen();
            },
          ),
          const SettingsScreen()
        ]),
        extendBody: true,
        bottomNavigationBar: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(values.medium),
                child: CustomNavigationBar(destinations: destinations),
              ),
            )),
      );
    }));
  }
}

class CustomNavigationBar extends StatelessWidget {
  final List<NavigationDestination> destinations;

  const CustomNavigationBar({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: destinations,
      height: Utils.appGetHeight(context, 7),
      backgroundColor: colors.accentDark,
      indicatorShape: null,
      indicatorColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 1000),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: context.read<NavigationCubit>().state,
      onDestinationSelected: (int index) =>
          context.read<NavigationCubit>().updateIndex(index),
    );
  }
}
