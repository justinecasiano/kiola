import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cubits/lesson_cubit.dart';
import '../models/cubits/navigation_cubit.dart';
import '../models/lesson.dart';
import '../widgets/custom_background.dart';
import '../widgets/rounded_container.dart';
import '../extras/utils.dart';

import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomBackground(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: values.medium),
      child: Column(children: [Header(), DashboardInfo(), Lessons()]),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: values.small + 3,
          bottom: values.small,
          left: values.small - 3,
          right: values.small - 3),
      child: Row(children: [
        Expanded(
          child: Text(
            'Welcome, Mark',
            style: values.getTextStyle(context, 'titleLarge',
                color: colors.primary, weight: FontWeight.w700),
          ),
        ),
        IconButton(
          onPressed: () {
            print("Profile is pressed");
          },
          icon: const Icon(
            Icons.person,
            size: values.large + 3,
            color: colors.primary,
          ),
        )
      ]),
    );
  }
}

class DashboardInfo extends StatelessWidget {
  const DashboardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(values.medium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(values.small + 7),
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
                              color: colors.accentDark,
                              weight: FontWeight.bold),
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
                                color: colors.accentDark,
                                weight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: values.small),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RoundedContainer(children: [
                              Text(
                                '100%',
                                textAlign: TextAlign.center,
                                style: values.getTextStyle(
                                    context, 'titleLarge',
                                    color: colors.accentLight,
                                    weight: FontWeight.bold),
                              ),
                              const SizedBox(height: values.small - 6),
                              Text(
                                'Pending',
                                textAlign: TextAlign.center,
                                style: values.getTextStyle(context, 'bodySmall',
                                    color: colors.secondary,
                                    weight: FontWeight.w500),
                              ),
                            ]),
                            const SizedBox(
                              width: values.small - 5,
                            ),
                            RoundedContainer(children: [
                              Text(
                                '0%',
                                textAlign: TextAlign.center,
                                style: values.getTextStyle(
                                    context, 'titleLarge',
                                    color: colors.accentLight,
                                    weight: FontWeight.bold),
                              ),
                              const SizedBox(height: values.small - 6),
                              Text(
                                'Completed',
                                textAlign: TextAlign.center,
                                style: values.getTextStyle(context, 'bodySmall',
                                    color: colors.secondary,
                                    weight: FontWeight.w500),
                              ),
                            ]),
                          ],
                        )
                      ])),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: values.large),
                  child: RoundedContainer(
                      padding: const EdgeInsets.symmetric(
                          vertical: values.small + 3),
                      children: [
                        Text(
                          '0%',
                          textAlign: TextAlign.center,
                          style: values.getTextStyle(context, 'headlineLarge',
                              color: colors.accentLight,
                              weight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ));
  }
}

class Lessons extends StatelessWidget {
  const Lessons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: values.medium),
      child: Container(
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(values.medium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(values.medium),
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: values.large),
                  child: Image.asset('assets/images/heron.png',
                      fit: BoxFit.cover)),
              Column(
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
              )
            ],
          ),
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
    Lesson? lesson = context.watch<LessonCubit>().state;

    return GestureDetector(
        onTap: () {
          context.read<LessonCubit>().setLesson(number);
          context.read<NavigationCubit>().updateIndex(1);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: values.medium),
          child: RoundedContainer(
              padding: EdgeInsets.zero,
              borderRadius: values.medium,
              children: [
                Stack(
                  children: [
                    SizedBox(
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
                          Container(
                            decoration: BoxDecoration(
                              color: colors.primary,
                              border: Border.all(
                                  width: 1,
                                  color: colors.secondary.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(values.small),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(values.small - 2),
                              child: Column(
                                children: [
                                  Text(
                                    '0$number',
                                    style: values.getTextStyle(
                                        context, 'titleLarge',
                                        color: colors.accentDark,
                                        weight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Lesson',
                                    style: values.getTextStyle(
                                        context, 'bodySmall',
                                        color: colors.secondary,
                                        weight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: values.small,
                          ),
                          Text(
                            lesson!.title.toUpperCase(),
                            style: values.getTextStyle(context, 'titleLarge',
                                color: colors.secondary,
                                weight: FontWeight.normal),
                          ),
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
                          Text(
                            'Module, Powerpoint, ${lesson!.hasVideo ? 'Video, ' : ''}Quiz',
                            style: values.getTextStyle(context, 'bodySmall',
                                color: colors.accentLighter,
                                weight: FontWeight.normal),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ]),
        ));
  }
}
