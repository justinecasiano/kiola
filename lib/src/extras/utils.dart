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

  static dynamic getLesson(int number) => {
        1: {
          'title': 'Introduction to Dance',
        },
        2: {
          'title': 'Dance Related Injuries',
        },
        3: {
          'title': 'Folk Dance in the Philippines',
          'hasVideo': 'Video, ',
        },
        4: {
          'title': 'Dancesport',
        },
        5: {
          'title': 'Cheerdance',
        },
        6: {
          'title': 'Hip-Hop and Street Dance',
        }
      }[number];
}
