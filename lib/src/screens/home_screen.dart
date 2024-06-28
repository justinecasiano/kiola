import 'package:flutter/material.dart';
import '../widgets/dashboard.dart';
import '../widgets/lesson.dart';
import '../widgets/settings.dart';
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

  List<Widget> widgets = const [Dashboard(), Lesson(), Settings()];
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.primaryShade,
        body: widgets[currentPageIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(values.medium),
            child: CustomNavigationBar(
                destinations: destinations,
                getIndex: () => currentPageIndex,
                setIndex: (int index) =>
                    setState(() => currentPageIndex = index)),
          ),
        ));
  }
}

class CustomNavigationBar extends StatefulWidget {
  final List<NavigationDestination> destinations;
  final Function() getIndex;
  final Function(int) setIndex;

  const CustomNavigationBar(
      {super.key,
      required this.destinations,
      required this.getIndex,
      required this.setIndex});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 45,
      backgroundColor: colors.accentDark,
      indicatorShape: null,
      indicatorColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 1000),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: widget.getIndex(),
      destinations: widget.destinations,
      onDestinationSelected: widget.setIndex,
    );
  }
}
