import 'package:flutter/material.dart';
import 'colors.dart' as colors;

const large = 25.0;
const medium = 20.0;
const small = 10.0;

double appGetHeight(BuildContext context, double percent) {
  return percent * MediaQuery.of(context).size.height / 100;
}

double appGetWidth(BuildContext context, double percent) {
  return percent * MediaQuery.of(context).size.width / 100;
}

TextStyle? getTextStyle(BuildContext context, String size,
    {Color color = colors.secondary, FontWeight weight = FontWeight.normal}) {
  var textTheme = Theme.of(context).textTheme;

  var textStyles = {
    'headlineLarge': textTheme.headlineLarge,
    'headlineMedium': textTheme.headlineMedium,
    'headlineSmall': textTheme.headlineSmall,
    'titleLarge': textTheme.titleLarge,
    'titleMedium': textTheme.titleMedium,
    'bodyLarge': textTheme.bodyLarge,
    'bodyMedium': textTheme.bodyMedium,
    'bodySmall': textTheme.bodySmall,
  };

  return textStyles[size]?.copyWith(color: color, fontWeight: weight);
}
