import 'package:flutter/material.dart';
import '../extras/utils.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final bool isScrollable;

  const CustomBackground(
      {super.key, required this.child, this.isScrollable = true});

  Widget getBackground(BuildContext context) {
    return SizedBox(
      width: Utils.appGetWidth(context, 100),
      height: 200,
      child:
          Image.asset('assets/images/custom-background.png', fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Utils.appGetHeight(context, 93),
      child: Builder(
        builder: (BuildContext context) {
          return ListView(
              physics:
                  isScrollable ? null : const NeverScrollableScrollPhysics(),
              children: [
                Stack(children: [getBackground(context), child]),
              ]);
        },
      ),
    );
  }
}
