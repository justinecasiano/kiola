import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../extras/utils.dart';
import '../models/cubits/navigation_cubit.dart';
import '../models/cubits/student_cubit.dart';
import '../widgets/custom_background.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;
import '../widgets/rounded_container.dart';

class AcknowledgementsScreen extends StatelessWidget {
  const AcknowledgementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const CustomBackground(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: values.medium),
        child: SizedBox(
          height: Utils.appGetHeight(context, 85),
          child: Column(children: [
            Header().animate(delay: 200.ms).fade(duration: 300.ms),
            Expanded(child: Contents())
          ]),
        ),
      ),
    ]);
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    int clickCount = 0;

    return Padding(
      padding: const EdgeInsets.only(
          top: values.medium,
          bottom: values.small,
          left: values.small - 3,
          right: values.small - 3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: SizedBox(
              width: Utils.appGetWidth(context, 65),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Acknowledgements',
                        style: values.getTextStyle(context, 'titleLarge',
                            color: colors.primary, weight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: values.small),
                    Text(
                      Utils.getDateTime('EEEE, MMMM d, y'),
                      style: values.getTextStyle(context, 'bodyMedium',
                          color: colors.primary, weight: FontWeight.w400),
                    ),
                  ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              bool shouldUnlockLessons =
                  context.read<StudentCubit>().state.shouldUnlockLessons;

              if (++clickCount == 5) {
                Utils.showToastMessage(
                    'All lessons ${shouldUnlockLessons ? 'locked' : 'unlocked'}');
                (shouldUnlockLessons)
                    ? context.read<StudentCubit>().setShouldUnlockLessons(false)
                    : context.read<StudentCubit>().setShouldUnlockLessons(true);
                clickCount = 0;
                context.read<NavigationCubit>().updateIndex(0);
              }
            },
            child: RoundedContainer(
              padding: EdgeInsets.zero,
              borderRadius: values.medium - 5,
              child: SizedBox(
                width: Utils.appGetWidth(context, 17),
                height: Utils.appGetWidth(context, 16),
                child: WebsafeSvg.asset('assets/images/app-icon.svg',
                    fit: BoxFit.fill),
              ),
            )
                .animate(onPlay: ((controller) => controller.repeat()))
                .scaleXY(delay: 2200.ms, end: 1.1, duration: 500.ms)
                .shake(duration: 750.ms)
                .scaleXY(delay: 2700.ms, end: 0.9, duration: 500.ms),
          ),
        ]),
        const SizedBox(height: values.large),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: values.medium),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Made with 💖',
              style: values.getTextStyle(context, 'titleLarge',
                  color: colors.primary, weight: FontWeight.w600),
            ).animate(delay: 500.ms).fade(duration: 500.ms),
          ),
        ),
        const SizedBox(height: values.small + 5),
      ]),
    );
  }
}

class Contents extends StatelessWidget {
  const Contents({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: EdgeInsets.zero,
      borderRadius: values.medium,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -values.medium,
            child: WebsafeSvg.asset('assets/images/heron.svg',
                fit: BoxFit.contain),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(values.medium),
                child: Column(children: [
                  const SizedBox(height: values.small),
                  SizedBox(
                    width: double.infinity,
                    height: Utils.appGetHeight(context, 18),
                    child: RoundedContainer(
                        padding: const EdgeInsets.all(values.small),
                        borderRadius: values.medium,
                        child: WebsafeSvg.asset('assets/images/kiola-logo.svg',
                            fit: BoxFit.cover)),
                  )
                      .animate(delay: 1000.ms)
                      .scale(duration: 200.ms)
                      .slideX(duration: 200.ms),
                  const SizedBox(height: values.large),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: values.medium,
                    runSpacing: values.small,
                    children: [
                      Image.asset(
                        'assets/images/logos/umak.png',
                        fit: BoxFit.fitHeight,
                        width: Utils.appGetHeight(context, 10),
                      ),
                      Image.asset(
                        'assets/images/logos/ccaps.png',
                        fit: BoxFit.fitHeight,
                        width: Utils.appGetHeight(context, 10),
                      ),
                      Image.asset(
                        'assets/images/logos/cite.png',
                        fit: BoxFit.fitHeight,
                        width: Utils.appGetHeight(context, 10),
                      ),
                      Image.asset(
                        'assets/images/logos/hsu.png',
                        fit: BoxFit.fitHeight,
                        width: Utils.appGetHeight(context, 10),
                      ),
                      Image.asset(
                        'assets/images/logos/cad.png',
                        fit: BoxFit.fitHeight,
                        width: Utils.appGetHeight(context, 10),
                      ),
                    ]
                        .animate(delay: 1100.ms, interval: 100.ms)
                        .scale(duration: 200.ms)
                        .slideX(duration: 200.ms),
                  ),
                  const SizedBox(height: values.large),
                  Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Mr. Justine J. Casiano',
                          style: values.getTextStyle(context, 'titleLarge',
                              color: colors.secondary, weight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Developer',
                        style: values.getTextStyle(context, 'titleMedium',
                            color: colors.accentDark, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: values.large),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Mr. Mark Kevin N. Picao',
                          style: values.getTextStyle(context, 'titleLarge',
                              color: colors.secondary, weight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Designer',
                        style: values.getTextStyle(context, 'titleMedium',
                            color: colors.accentDark, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: values.large),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Ms. Kio Mae D. Marvida',
                          style: values.getTextStyle(context, 'titleLarge',
                              color: colors.secondary, weight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Researcher',
                        style: values.getTextStyle(context, 'titleMedium',
                            color: colors.accentDark, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: values.large),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Mr. Dominador B. Lera Jr.',
                          style: values.getTextStyle(context, 'titleLarge',
                              color: colors.secondary, weight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Research Adviser',
                        style: values.getTextStyle(context, 'titleMedium',
                            color: colors.accentDark, weight: FontWeight.w600),
                      ),
                    ]
                        .animate(delay: 1600.ms, interval: 100.ms)
                        .fade(duration: 200.ms)
                  )
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
