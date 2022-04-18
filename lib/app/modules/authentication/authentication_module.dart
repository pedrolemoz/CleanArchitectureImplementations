import 'package:animations/animations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/packages/firebase/firebase_authentication_client/implementation/firebase_authentication_client_implementation.dart';
import 'domain/usecases/authentication_with_credentials.dart';
import 'external/firebase_login_datasource_implementation.dart';
import 'infrastructure/repositories/login_repository_implementation.dart';
import 'presentation/controllers/bloc/login_bloc.dart';
import 'presentation/pages/login_page.dart';
import 'utils/validators/authentication_validators.dart';

class AuthenticationModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => FirebaseAuthenticationClientImplementation()),
        Bind((i) => FirebaseLoginDataSourceImplementation(i(), i(), i())),
        Bind((i) => LoginRepositoryImplementation(i(), i())),
        Bind((i) => const AuthenticationValidatorsImplementation()),
        Bind((i) => AuthenticationWithCredentialsImplementation(i(), i())),
        Bind((i) => LoginBloc(i(), i()))
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => LoginPage(),
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
        )
      ];
}
