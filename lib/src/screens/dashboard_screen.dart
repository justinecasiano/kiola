import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../models/cubits/lesson_cubit.dart';
import '../models/cubits/navigation_cubit.dart';
import '../models/cubits/student_cubit.dart';
import '../models/student.dart';
import '../widgets/custom_background.dart';
import '../widgets/rounded_container.dart';
import '../extras/utils.dart';

import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> showUserProfile(BuildContext context) async {
    Student student = context.read<StudentCubit>().state;
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colors.primary,
          title: Text(
            'User Profile',
            style: values.getTextStyle(context, 'titleLarge',
                color: colors.secondary, weight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Username: ${student.username ?? ''}',
                  style: values.getTextStyle(context, 'titleMedium',
                      color: colors.secondary, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: values.small - 5),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Email: ${student.email ?? ''}',
                  overflow: TextOverflow.ellipsis,
                  style: values.getTextStyle(context, 'titleMedium',
                      color: colors.secondary, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: values.large),
              ...student
                  .getQuizScores()
                  .asMap()
                  .entries
                  .map(
                    (score) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Quiz ${score.key + 1}: ${score.value != null ? '${score.value} / 10' : 'Not yet taken'}',
                        style: values.getTextStyle(context, 'titleMedium',
                            color: colors.secondary, weight: FontWeight.w500),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: values.getTextStyle(context, 'titleMedium',
                    color: colors.accentDark, weight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            const CustomBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: values.medium),
              child: Column(
                children: [
                  Header(onPressed: () => showUserProfile(context))
                      .animate(delay: 200.ms)
                      .fade(duration: 300.ms),
                  DashboardInfo(),
                  Lessons(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final Function() onPressed;

  const Header({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final username = BlocSelector<StudentCubit, Student, String>(
      selector: (state) => state.username?.split(' ')[0] ?? '',
      builder: (BuildContext context, String username) {
        return Text(
          '$username',
          style: values.getTextStyle(context, 'titleLarge',
              color: colors.primary, weight: FontWeight.w700),
        )
            .animate(delay: 1500.ms)
            .fade(duration: 500.ms)
            .then()
            .shimmer(blendMode: BlendMode.color, duration: 2000.ms);
      },
    );

    return Padding(
      padding: const EdgeInsets.only(
          top: values.small + 3,
          bottom: values.small,
          left: values.small - 3,
          right: values.small - 3),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(
                    'Welcome, ',
                    style: values.getTextStyle(context, 'titleLarge',
                        color: colors.primary, weight: FontWeight.w700),
                  ),
                  username
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.person,
              size: values.large + 3,
              color: colors.primary,
            ),
          )
              .animate(onPlay: ((controller) => controller.repeat()))
              .scaleXY(delay: 4000.ms, end: 1.1, duration: 500.ms)
              .shake(duration: 750.ms)
              .scaleXY(delay: 4500.ms, end: 0.9, duration: 500.ms)
        ],
      ),
    );
  }
}

class DashboardInfo extends StatelessWidget {
  const DashboardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = BlocSelector<StudentCubit, Student, int>(
      selector: (state) => state.overallProgress.round(),
      builder: (BuildContext context, int overallProgress) {
        return Text(
          '${100 - overallProgress}%',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'titleLarge',
              color: colors.accentLight, weight: FontWeight.bold),
        );
      },
    );

    final completed = BlocSelector<StudentCubit, Student, int>(
      selector: (state) => state.overallProgress.round(),
      builder: (BuildContext context, int overallProgress) {
        return Text(
          '$overallProgress%',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'titleLarge',
              color: colors.accentLight, weight: FontWeight.bold),
        );
      },
    );

    final overall = BlocSelector<StudentCubit, Student, int>(
      selector: (state) => state.overallProgress.round(),
      builder: (BuildContext context, int overallProgress) {
        return Text(
          '$overallProgress%',
          textAlign: TextAlign.center,
          style: values.getTextStyle(context, 'headlineLarge',
              color: colors.accentLight, weight: FontWeight.bold),
        );
      },
    );

    return RoundedContainer(
      padding: const EdgeInsets.all(values.medium),
      borderRadius: values.medium,
      child: Row(
        children: [
          SizedBox(
              width: Utils.appGetWidth(context, 55),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: values.getTextStyle(context, 'titleLarge',
                          color: colors.accentDark, weight: FontWeight.bold),
                    ),
                    const SizedBox(height: values.small),
                    Text(
                      Utils.getDateTime('EEEE, MMMM d y'),
                      style: values.getTextStyle(context, 'bodyMedium',
                          color: colors.secondary, weight: FontWeight.w500),
                    ),
                    const SizedBox(height: values.medium),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Progress',
                        style: values.getTextStyle(context, 'titleMedium',
                            color: colors.accentDark, weight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: values.small),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: values.small),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: RoundedContainer(
                              child: Column(children: [
                                pending,
                                const SizedBox(height: values.small - 6),
                                FittedBox(
                                  child: Text(
                                    'Pending',
                                    textAlign: TextAlign.center,
                                    style: values.getTextStyle(
                                        context, 'bodySmall',
                                        color: colors.secondary,
                                        weight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(
                            width: values.small,
                          ),
                          Expanded(
                            child: RoundedContainer(
                              child: Column(children: [
                                completed,
                                const SizedBox(height: values.small - 6),
                                FittedBox(
                                  child: Text(
                                    'Completed',
                                    textAlign: TextAlign.center,
                                    style: values.getTextStyle(
                                        context, 'bodySmall',
                                        color: colors.secondary,
                                        weight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    )
                  ])),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: values.large),
              child: RoundedContainer(
                padding: const EdgeInsets.symmetric(vertical: values.small + 3),
                child: overall,
              )
                  .animate(onPlay: ((controller) => controller.repeat()))
                  .scaleXY(delay: 4000.ms, end: 1.1, duration: 500.ms)
                  .shake(duration: 750.ms)
                  .scaleXY(delay: 4500.ms, end: 0.9, duration: 500.ms),
            ),
          ),
        ],
      ).animate(delay: 500.ms).fade(duration: 500.ms),
    );
  }
}

class Lessons extends StatelessWidget {
  const Lessons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: values.medium),
      child: RoundedContainer(
        borderRadius: values.medium,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned(
              left: -values.medium,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: values.large + values.medium),
                child: WebsafeSvg.asset('assets/images/heron.svg',
                    fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(values.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: values.small - 5),
                    child: Text(
                      'Lessons:',
                      style: values.getTextStyle(context, 'titleLarge',
                          color: colors.secondary, weight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: values.large),
                  const LessonCard(number: 1),
                  const LessonCard(number: 2),
                  const LessonCard(number: 3),
                  const LessonCard(number: 4),
                  const LessonCard(number: 5),
                  const LessonCard(number: 6),
                ],
              ).animate(delay: 1000.ms).fade(duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final int number;

  const LessonCard({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    final title = Builder(
      builder: (BuildContext context) {
        return Text(
          context.read<LessonCubit>().getLesson(number).title.toUpperCase(),
          style: values.getTextStyle(context, 'titleLarge',
              color: colors.secondary, weight: FontWeight.normal),
        );
      },
    );

    final hasVideo = Builder(
      builder: (BuildContext context) {
        return Text(
          'Module, Powerpoint, ${context.read<LessonCubit>().getLesson(number).hasVideo ? 'Video, ' : ''}Quiz',
          style: values.getTextStyle(context, 'bodySmall',
              color: colors.accentLighter, weight: FontWeight.normal),
        );
      },
    );

    return GestureDetector(
        onTap: () {
          context.read<LessonCubit>().setLesson(context, number);
          context.read<NavigationCubit>().updateIndex(1);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: values.medium),
          child: RoundedContainer(
              padding: EdgeInsets.zero,
              borderRadius: values.medium,
              child: Stack(
                children: [
                  SizedBox(
                    width: Utils.appGetWidth(context, 100),
                    height: 115,
                    child: Image.asset(
                      fit: BoxFit.cover,
                      'assets/images/thumbnails/lesson/lesson-$number.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: values.medium,
                        right: values.medium,
                        bottom: values.small),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        RoundedContainer(
                          padding: const EdgeInsets.symmetric(
                              vertical: values.small,
                              horizontal: values.medium - 5),
                          borderRadius: values.medium,
                          child: Column(
                            children: [
                              Text(
                                '0$number',
                                style: values.getTextStyle(
                                    context, 'headlineSmall',
                                    color: colors.accentDark,
                                    weight: FontWeight.bold),
                              ),
                              Text(
                                'Lesson',
                                style: values.getTextStyle(context, 'bodySmall',
                                    color: colors.secondary,
                                    weight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: values.small,
                        ),
                        title,
                        const SizedBox(
                          height: values.small,
                        ),
                        Text(
                          'Contents Overview',
                          style: values.getTextStyle(context, 'bodySmall',
                              color: colors.accentLighter,
                              weight: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: values.small,
                        ),
                        hasVideo,
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}
