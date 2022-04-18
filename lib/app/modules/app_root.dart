import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:magnet_ui/magnet_ui.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      theme: AppTheme.light(fontFamily: 'Poppins'),
      title: 'Clean Architecture Implementations',
      debugShowCheckedModeBanner: false,
    );
  }
}
