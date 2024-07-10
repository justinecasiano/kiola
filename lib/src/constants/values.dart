import 'package:flutter/material.dart';
import 'colors.dart' as colors;

const large = 25.0;
const medium = 20.0;
const small = 10.0;

TextStyle? getTextStyle(BuildContext context, String size,
    {Color color = colors.secondary, FontWeight weight = FontWeight.normal}) {
  var textTheme = Theme.of(context).textTheme;

  var textStyles = {
    'headlineLarge': textTheme.headlineLarge,
    'headlineMedium': textTheme.headlineMedium,
    'headlineSmall': textTheme.headlineSmall,
    'titleLarge': textTheme.titleLarge,
    'titleMedium': textTheme.titleMedium,
    'titleSmall': textTheme.titleSmall,
    'bodyLarge': textTheme.bodyLarge,
    'bodyMedium': textTheme.bodyMedium,
    'bodySmall': textTheme.bodySmall,
  };

  return textStyles[size]?.copyWith(color: color, fontWeight: weight);
}
