import 'package:flutter/material.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class RoundedContainer extends StatelessWidget {
  final List<Widget> children;
  final double borderRadius;
  final EdgeInsets padding;

  const RoundedContainer(
      {super.key,
      required this.children,
      this.borderRadius = values.small,
      this.padding = const EdgeInsets.all(values.small - 2)});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.primary,
        border: Border.all(width: 1, color: colors.secondary.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
