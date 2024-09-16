import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../extras/utils.dart';
import '../widgets/rounded_container.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> contents = [
      Column(
        children: [
          Text(
            'Vision',
            style: values.getTextStyle(context, 'headlineMedium',
                color: colors.accentLight, weight: FontWeight.bold),
          ),
          const SizedBox(height: values.small),
          Text(
            'As the Laboratory School of the College of Innovative Education, the Higher School ng UMak envisions to be a leader of innovation in Senior High School education aiding the achievement of the college’s vision to produce quality teachers and academic leaders for the nation and the world.',
            textAlign: TextAlign.justify,
            style: values.getTextStyle(context, 'titleMedium',
                color: colors.secondary, weight: FontWeight.w600),
          ),
        ].animate(delay: 100.ms, interval: 100.ms).fade(duration: 200.ms),
      ),
      Column(
        children: [
          Text(
            'Mission',
            style: values.getTextStyle(context, 'headlineMedium',
                color: colors.accentLight, weight: FontWeight.bold),
          ),
          const SizedBox(height: values.small),
          Text(
            'In partnership with CITE, the Higher School ng UMak is dedicated to producing college-ready, work-ready, and business-ready Senior High School graduates equipped with 21st century skills. It further aims to develop every student’s whole person through transformative and innovative education.',
            textAlign: TextAlign.justify,
            style: values.getTextStyle(context, 'titleMedium',
                color: colors.secondary, weight: FontWeight.w600),
          ),
        ].animate(delay: 100.ms, interval: 100.ms).fade(duration: 200.ms),
      ),
      Column(
        children: [
          Text(
            'Core Values',
            style: values.getTextStyle(context, 'headlineMedium',
                color: colors.accentLight, weight: FontWeight.bold),
          ),
          const SizedBox(height: values.small),
          Text(
            'I-NNOVATIVE\nL-EADERSHIP\nE-XCELLENCE\nA-LTRUISM\nR-ESILIENCE\nN-ATIONALISM',
            style: values.getTextStyle(context, 'titleMedium',
                color: colors.secondary, weight: FontWeight.bold),
          ),
        ].animate(delay: 100.ms, interval: 100.ms).fade(duration: 200.ms),
      ),
      Column(
        children: [
          Text(
            'KIOLA',
            style: values.getTextStyle(context, 'headlineMedium',
                color: colors.accentLight, weight: FontWeight.bold),
          ),
          const SizedBox(height: values.small),
          Text(
            'is an android-based application as a learning aid specifically designed and aligned to DepEd Most Essential Learning Competencies (MELCS) for Physical Education and Health 3 subject in the Higher School ng UMak (HSU).',
            textAlign: TextAlign.justify,
            style: values.getTextStyle(context, 'titleMedium',
                color: colors.secondary, weight: FontWeight.w600),
          ),
        ].animate(delay: 100.ms, interval: 100.ms).fade(duration: 200.ms),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: WebsafeSvg.asset('assets/images/splash-background.svg',
                  fit: BoxFit.cover),
            ),
            PageView.builder(
              itemCount: contents.length,
              onPageChanged: (index) {
                tabController.index = index++;
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: values.medium),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedContainer(
                            borderRadius: values.large,
                            padding: EdgeInsets.all(values.large),
                            child: contents[index]),
                        const SizedBox(height: values.large),
                        if (index == contents.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.restorablePushReplacementNamed(
                                  context, '/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              overlayColor: colors.accentDark,
                              padding: EdgeInsets.symmetric(
                                  horizontal: values.medium,
                                  vertical: values.small),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    values.large + values.large),
                              ),
                            ),
                            child: Text(
                              'Proceed',
                              style: values.getTextStyle(context, 'titleMedium',
                                  color: colors.accentDark,
                                  weight: FontWeight.bold),
                            ),
                          ),
                      ]),
                );
              },
            ),
            Positioned(
              bottom: Utils.appGetHeight(context, 5),
              child: TabPageSelector(
                controller: tabController,
                color: colors.primary,
                selectedColor: colors.accentLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
