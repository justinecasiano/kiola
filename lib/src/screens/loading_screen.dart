import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;
import '../extras/utils.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
                Center(
                  child: WebsafeSvg.asset('assets/images/app-icon-white.svg',
                      width: Utils.appGetWidth(context, 50), fit: BoxFit.cover),
                ),
                const SizedBox(height: values.small),
                CircularProgressIndicator(color: colors.primary)
              ],
            )
          ],
        ),
      ),
    );
  }
}
