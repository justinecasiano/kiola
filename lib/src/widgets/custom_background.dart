import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: WebsafeSvg.asset('assets/images/home-background.svg',
          fit: BoxFit.cover),
    );
  }
}
