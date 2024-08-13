import 'package:flutter/material.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class RoundedContainer extends StatelessWidget {
  final Widget? child;
  final Color color;
  final EdgeInsets padding;
  final Border? border;
  final double borderRadius;

  const RoundedContainer({
    super.key,
    this.child,
    this.color = colors.primary,
    this.padding = const EdgeInsets.all(values.small - 2),
    this.border = null,
    this.borderRadius = values.small,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        border: border ??
            Border.all(width: 1, color: colors.secondary.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
