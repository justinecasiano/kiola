import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static double appGetHeight(BuildContext context, double percent) {
    return percent * MediaQuery.of(context).size.height / 100;
  }

  static double appGetWidth(BuildContext context, double percent) {
    return percent * MediaQuery.of(context).size.width / 100;
  }

  static String getDateTime(String pattern) {
    return DateFormat(pattern)
        .format(DateTime.now().toUtc().add(const Duration(hours: 8)));
  }

  static int getSecondsSinceEpoch() {
    return DateTime.now()
            .toUtc()
            .add(const Duration(hours: 8))
            .millisecondsSinceEpoch ~/
        Duration.millisecondsPerSecond;
  }

  static dynamic loadJson(BuildContext context, String path) async {
    String data = await DefaultAssetBundle.of(context).loadString(path);
    return jsonDecode(data);
  }
}
