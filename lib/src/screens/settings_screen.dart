import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../extras/utils.dart';
import '../widgets/custom_background.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;
import '../widgets/rounded_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    Text(
                      'Settings',
                      style: values.getTextStyle(context, 'titleLarge',
                          color: colors.primary, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: values.small),
                    Text(
                      Utils.getDateTime('EEEE, MMMM d y'),
                      style: values.getTextStyle(context, 'bodyMedium',
                          color: colors.primary, weight: FontWeight.w400),
                    ),
                  ]),
            ),
          ),
          RoundedContainer(
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
            children: [
              Padding(
                padding: const EdgeInsets.all(values.medium),
                child: Column(
                  children: [
                    const SizedBox(height: values.small),
                    SizedBox(
                      width: double.infinity,
                      height: Utils.appGetHeight(context, 18),
                      child: RoundedContainer(
                          padding: const EdgeInsets.all(values.small),
                          borderRadius: values.medium,
                          child: WebsafeSvg.asset(
                              'assets/images/kiola-logo.svg',
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(height: values.large),
                    SizedBox(
                      width: double.infinity,
                      height: Utils.appGetHeight(context, 18),
                      child: RoundedContainer(
                        padding: const EdgeInsets.all(values.small),
                        borderRadius: values.medium,
                        child: FlutterLogo(
                          textColor: colors.accentDark,
                          style: FlutterLogoStyle.horizontal,
                        ),
                      ),
                    ),
                  ]
                      .animate(delay: 1000.ms, interval: 100.ms)
                      .scale(duration: 200.ms)
                      .slideX(duration: 200.ms),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
