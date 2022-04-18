import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:magnet_ui/magnet_ui.dart';
import 'package:unicons/unicons.dart';

import '../controllers/bloc/login_bloc.dart';
import '../controllers/events/authentication_events.dart';

class LoginPage extends StatelessWidget {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final loginBloc = Modular.get<LoginBloc>();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, AppState>(
      bloc: loginBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Clean Arch Login'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login with your credentials',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InputText(
                        controller: emailTextController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        enablePrefixIcon: true,
                        prefixIcon: UniconsLine.at,
                      ),
                      const SizedBox(height: 8),
                      InputText(
                        controller: passwordTextController,
                        hintText: 'Password',
                        enablePrefixIcon: true,
                        prefixIcon: UniconsLine.padlock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () {
                          loginBloc.add(
                            AuthenticationWithCredentialsEvent(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                            ),
                          );
                        },
                        text: 'Login with credentials',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Or use a social login',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        enableButton: false,
                        onPressed: () {},
                        color: const Color(0xFF4285F4),
                        enableIcon: true,
                        icon: UniconsLine.google,
                        text: 'Login with Google',
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        enableButton: false,
                        onPressed: () {},
                        color: const Color(0xFF4267B3),
                        enableIcon: true,
                        icon: UniconsLine.facebook_f,
                        text: 'Login with Facebook',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
