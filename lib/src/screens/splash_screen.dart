import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiola/src/models/student.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../extras/utils.dart';
import '../models/cubits/student_cubit.dart';
import '../widgets/register.dart';
import '../constants/colors.dart' as colors;
import '../constants/values.dart' as values;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Student? student;
  bool modalSheetActive = false;

  @override
  void initState() {
    super.initState();
    student = context.read<StudentCubit>().state;
    controller = BottomSheet.createAnimationController(this)
      ..duration = 1000.ms;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showRegisterModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: colors.primary,
      transitionAnimationController: controller,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(values.large),
          topRight: Radius.circular(values.large),
        ),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const Register(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: WebsafeSvg.asset('assets/images/splash-background.svg',
                  fit: BoxFit.cover),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WebsafeSvg.asset('assets/images/kiola-logo-white.svg',
                    fit: BoxFit.cover),
                ElevatedButton(
                  onPressed: () {
                    (student!.username == null)
                        ? showRegisterModal()
                        : Navigator.restorablePushReplacementNamed(
                            context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding: EdgeInsets.symmetric(
                        horizontal: values.medium, vertical: values.small),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(values.large + values.large),
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: values.getTextStyle(context, 'titleLarge',
                        color: colors.accentDark, weight: FontWeight.bold),
                  ),
                ),
              ]
                  .animate(delay: 200.ms, interval: 1000.ms)
                  .fade(duration: 900.ms),
            ),
          ],
        ),
      ),
    );
  }
}
