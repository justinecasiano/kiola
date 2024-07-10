import 'package:flutter/material.dart';
import '../extras/utils.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Utils.appGetHeight(context, 93),
      child: ListView(children: [
        Stack(children: [
          SizedBox(
            width: Utils.appGetWidth(context, 100),
            height: 200,
            child: Image.asset('assets/images/custom-background.png',
                fit: BoxFit.cover),
          ),
          child
        ]),
      ]),
    );
  }
}
