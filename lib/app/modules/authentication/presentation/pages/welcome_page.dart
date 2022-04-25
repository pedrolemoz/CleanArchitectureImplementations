import 'package:flutter/material.dart';

import '../../../../core/domain/entities/user.dart';

class WelcomePage extends StatelessWidget {
  final User user;

  const WelcomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.userName.firstName}'),
      ),
    );
  }
}
