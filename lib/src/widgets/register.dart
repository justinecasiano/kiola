import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../constants/colors.dart' as colors;
import '../constants/values.dart' as values;
import '../extras/utils.dart';
import '../models/cubits/student_cubit.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  bool isUsernameValid = true;
  bool isEmailValid = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  TextField createTextField(
    String hintText,
    String errorText,
    bool isValid,
    TextEditingController controller,
    Function(String) onChange,
  ) {
    return TextField(
      controller: controller,
      cursorColor: colors.secondary,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: onChange,
      style: values.getTextStyle(context, 'titleMedium',
          color: colors.secondary, weight: FontWeight.bold),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: values.large, vertical: values.medium),
        border: isValid
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(values.large * 2),
                borderSide: BorderSide(color: colors.secondary, width: 3),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(values.large * 2),
                borderSide: BorderSide(color: Colors.red, width: 3),
              ),
        focusedBorder: isValid
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(values.large * 2),
                borderSide: BorderSide(color: colors.secondary, width: 3),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(values.large * 2),
                borderSide: BorderSide(color: Colors.red, width: 3),
              ),
        errorText: isValid ? null : errorText,
        errorStyle: isValid
            ? null
            : values.getTextStyle(context, 'bodySmall',
                color: Colors.red, weight: FontWeight.bold),
        hintText: hintText,
        hintStyle: values.getTextStyle(context, 'titleMedium',
            color: colors.secondary, weight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: values.large + values.small,
          left: -(values.large + values.large + values.small),
          child: WebsafeSvg.asset('assets/images/heron.svg', fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.only(top: values.large + values.large),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register to KIOLA',
                style: values.getTextStyle(context, 'titleLarge',
                    color: colors.secondary, weight: FontWeight.bold),
              ),
              const SizedBox(height: values.large),
              Text(
                'What should we call you?',
                style: values.getTextStyle(context, 'titleMedium',
                    color: colors.secondary, weight: FontWeight.w600),
              ),
              const SizedBox(height: values.medium),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Utils.appGetWidth(context, 12)),
                child: createTextField(
                  'Juan dela Cruz',
                  'Invalid username',
                  isUsernameValid,
                  usernameController,
                  (value) {
                    setState(() =>
                        isUsernameValid = Utils.validate('username', value)!);
                  },
                ),
              ),
              const SizedBox(height: values.medium),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Utils.appGetWidth(context, 12)),
                child: createTextField(
                  'jdelacruz@umak.edu.ph',
                  'Invalid email',
                  isEmailValid,
                  emailController,
                  (value) {
                    setState(
                        () => isEmailValid = Utils.validate('email', value)!);
                  },
                ),
              ),
              const SizedBox(height: values.large),
              ElevatedButton(
                child: Text(
                  'Register',
                  style: values.getTextStyle(context, 'titleMedium',
                      color: colors.primary, weight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accentDark,
                  padding: EdgeInsets.symmetric(
                      horizontal: values.medium, vertical: values.small),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(values.large + values.large),
                  ),
                ),
                onPressed: () {
                  if (Utils.validate('username', usernameController.text)!) {
                    if (Utils.validate('email', emailController.text)!) {
                      Utils.showToastMessage('Registering...');
                      context.read<StudentCubit>().setInfo(
                          usernameController.text, emailController.text);

                      Future.delayed(
                        2000.ms,
                        () {
                          Navigator.pop(context);
                          Navigator.restorablePushReplacementNamed(
                              context, '/intro');
                        },
                      );
                    } else {
                      setState(() => isEmailValid = false);
                    }
                  } else {
                    setState(() => isUsernameValid = false);
                  }
                },
              ),
              const SizedBox(height: values.large + values.small),
            ],
          ),
        ),
      ],
    );
  }
}
