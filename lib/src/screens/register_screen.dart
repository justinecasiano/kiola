import 'package:flutter/material.dart';
import '../constants/values.dart' as values;
import '../constants/colors.dart' as colors;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const RegisterForm();
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(values.large),
            topRight: Radius.circular(values.large),
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome to Kiola',
              style: values.getTextStyle(context, 'titleLarge'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: values.small),
            Text(
              'What should we call you?',
              style: values.getTextStyle(context, 'bodyLarge'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: values.small),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Please enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(values.medium),
                  borderSide: const BorderSide(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
