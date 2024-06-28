import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_management_system/src/widgets/custom_background.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class Dashboard extends StatelessWidget {
  
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomBackground(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: values.medium),
      child: SizedBox(
        child: Column(children: [Header(), DashboardInfo(), Lessons()]),
      ),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: values.small, horizontal: values.small - 3),
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
            print("Profile is presed");
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
          padding: const EdgeInsets.all(values.small + 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
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
                      DateFormat('EEEE, MMMM d y').format(DateTime.now()),
                      style: values.getTextStyle(context, 'bodySmall',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.primary,
                              border: Border.all(
                                  width: 1,
                                  color: colors.secondary.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(values.small),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: values.small - 5),
                              child: Column(children: [
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
                                  style: values.getTextStyle(
                                      context, 'bodySmall',
                                      color: colors.secondary,
                                      weight: FontWeight.w500),
                                ),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: values.small,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.primary,
                              border: Border.all(
                                  width: 1,
                                  color: colors.secondary.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(values.small),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: values.small - 5),
                              child: Column(children: [
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
                                  style: values.getTextStyle(
                                      context, 'bodySmall',
                                      color: colors.secondary,
                                      weight: FontWeight.w500),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    )
                  ])),
              Padding(
                padding: const EdgeInsets.only(bottom: values.large),
                child: Container(
                  width: values.appGetWidth(context, 25),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    border: Border.all(
                        width: 1, color: colors.secondary.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(values.small),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(values.small - 2),
                    child: Text(
                      '0%',
                      textAlign: TextAlign.center,
                      style: values.getTextStyle(context, 'headlineLarge',
                          color: colors.accentLight, weight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class Lessons extends StatelessWidget {
  const Lessons({super.key});

  void onTap() {
    print('Lesson is pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: values.medium),
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
                  LessonCard(
                      onTap: onTap,
                      thumbnail: 'assets/images/lesson-1-thumbnail.png',
                      number: '01',
                      title: 'INTRODUCTION TO DANCE'),
                  LessonCard(
                      onTap: onTap,
                      thumbnail: 'assets/images/lesson-2-thumbnail.png',
                      number: '02',
                      title: 'DANCE RELATED INJURIES'),
                  LessonCard(
                      onTap: onTap,
                      thumbnail: 'assets/images/lesson-3-thumbnail.png',
                      number: '03',
                      title: 'FOLK DANCE IN THE PHILIPPINES'),
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
  final Function() onTap;
  final String thumbnail;
  final String number;
  final String title;

  const LessonCard(
      {super.key,
      required this.onTap,
      required this.thumbnail,
      required this.number,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: values.medium),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.primary,
              border:
                  Border.all(width: 1, color: colors.secondary.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(values.medium),
            ),
            child: Stack(
              children: [
                Image.asset(thumbnail, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.only(
                      left: values.medium, bottom: values.small),
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
                              width: 1, color: colors.secondary.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(values.small),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(values.small - 2),
                          child: Column(
                            children: [
                              Text(
                                number,
                                style: values.getTextStyle(context, 'titleLarge',
                                    color: colors.accentDark,
                                    weight: FontWeight.bold),
                              ),
                              Text(
                                'Lesson',
                                style: values.getTextStyle(context, 'bodySmall',
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
                        title,
                        style: values.getTextStyle(context, 'titleLarge',
                            color: colors.secondary, weight: FontWeight.normal),
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
                        'Module, Powerpoint, Quiz',
                        style: values.getTextStyle(context, 'bodySmall',
                            color: colors.accentLighter,
                            weight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
