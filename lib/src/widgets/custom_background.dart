import 'package:flutter/material.dart';
import '../constants/values.dart' as values;

class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: values.appGetHeight(context, 91),
      child: ListView(children: [
        Stack(children: [
          SizedBox(
            width: values.appGetWidth(context, 100),
            height: values.appGetHeight(context, 35),
            child: Image.asset('assets/images/custom-background.png',
                fit: BoxFit.cover),
          ),
          child
        ]),
      ]),
    );
  }
}
