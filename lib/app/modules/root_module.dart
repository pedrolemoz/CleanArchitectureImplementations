import 'package:animations/animations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'authentication/authentication_module.dart';

class RootModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(
          '/',
          module: AuthenticationModule(),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
            transitionDuration: const Duration(milliseconds: 400),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
          ),
        ),
      ];
}
