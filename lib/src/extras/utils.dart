import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cubits/student_cubit.dart';
import '../models/student.dart';
import '../constants/colors.dart' as colors;
import '../constants/values.dart' as values;

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

  static bool? validate(String info, String value) {
    return {
      'username':
          RegExp(r'^[a-zA-Z0-9]{4}[a-zA-Z0-9\s.]{0,16}$').hasMatch(value),
      'email': RegExp(r'^[a-zA-Z0-9.]{4,}@[a-zA-Z0-9.]+\.[a-zA-Z0-9.]{3,}$')
          .hasMatch(value),
    }[info];
  }

  static void showToastMessage(String message) async {
    Fluttertoast.cancel();
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colors.primary,
      textColor: colors.accentDark,
      fontSize: values.small + 5,
    );
  }

  static dynamic loadJsonFromAsset(BuildContext context, String path) async {
    String data = await DefaultAssetBundle.of(context).loadString(path);
    return jsonDecode(data);
  }

  static Future<dynamic> loadJsonFromSharedPref() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    final String? data = await asyncPrefs.getString('student');
    return data != null ? jsonDecode(data) : null;
  }

  static Future<dynamic> loadStudentData(
      BuildContext context, String path) async {
    final dynamic sharedPrefData = await loadJsonFromSharedPref();
    return sharedPrefData ?? await loadJsonFromAsset(context, path);
  }

  static void updateLocalStudentData(Student student) async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setString('student', jsonEncode(student.toJson()));
  }

  static Future<bool> hasInternetConnection() async {
    bool result = await InternetConnection().hasInternetAccess;
    result ? print('Connected to the internet') : print('No internet access');
    return result;
  }

  static Future<void> handleRedirect(
      Dio dio, Response<dynamic> response) async {
    final redirect = await dio.request(
      response.headers.value('location')!,
      options: Options(method: "GET"),
    );
    response.data = redirect.data;
  }

  static Future<void> updateRemoteStudentData(
      BuildContext context, Student student,
      {int retries = 3}) async {
    if (!(await hasInternetConnection())) return;

    print('Updating remote student data');
    showToastMessage('Saving progress');
    String endpoint =
        'https://script.google.com/macros/s/AKfycbzGUN6GEiPZmK61-OKgy9uxpLbHlc1rg-eUEBbfZLrzidGnmlE9iSxZAba-029P5p4u1g/exec';

    final dio = Dio();
    final response = await dio.post(
      endpoint,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json'
        },
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
      data: jsonEncode(student.toJson()),
    );

    if (response.statusCode == 302) await handleRedirect(dio, response);
    print(response.data);

    if (response.data['status'] == 'success') {
      context.read<StudentCubit>().setShouldUpdate(false);
      showToastMessage('Success saving progress');
    } else if (retries > 0) {
      updateRemoteStudentData(context, student, retries: retries - 1);
    } else {
      print('Failed to update remote student data, after 5 retries');
      showToastMessage('Failed saving progress');
    }
  }
}
