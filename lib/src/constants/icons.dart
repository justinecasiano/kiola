import 'package:flutter/material.dart';
import '../constants/colors.dart' as colors;

Icon getIcon(String name, {bool selected = false}) {
  const icons = {
    'dashboard': Icons.dashboard,
    'lesson': Icons.library_books,
    'acknowledgements': Icons.workspace_premium,
    'dashboard-outline': Icons.dashboard_outlined,
    'lesson-outline': Icons.library_books_outlined,
    'acknowledgements-outline': Icons.workspace_premium_outlined
  };

  name = selected ? name : '$name-outline';
  return Icon(icons[name], color: colors.primary);
}
