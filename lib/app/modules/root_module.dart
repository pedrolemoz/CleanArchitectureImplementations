import 'package:animations/animations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/external/checkers/network_connectivity_checker/implementations/network_connectivity_checker_implementation.dart';
import '../core/infrastructure/handlers/core_exceptions_handler_implementation.dart';
import '../core/packages/firebase/firebase_firestore_client/implementation/firebase_firestore_client_implementation.dart';
import '../core/presentation/controllers/handlers/core_states_handler_implementation.dart';
import 'authentication/authentication_module.dart';

class RootModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => CoreExceptionsHandlerImplementation()),
        Bind((i) => CoreStatesHandlerImplementation()),
        Bind((i) => NetworkConnectivityCheckerImplementation()),
        Bind((i) => FirebaseFirestoreClientImplementation()),
      ];

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
