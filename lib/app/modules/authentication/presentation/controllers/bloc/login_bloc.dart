import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:magnet_ui/magnet_ui.dart';

import '../../../../../core/presentation/controllers/handlers/core_states_handler.dart';
import '../../../domain/errors/authentication_failures.dart';
import '../../../domain/parameters/authentication_with_credentials_parameters.dart';
import '../../../domain/usecases/authentication_with_credentials.dart';
import '../events/authentication_events.dart';
import '../states/authentication_states.dart';

class LoginBloc extends Bloc<AuthenticationEvents, AppState> with Disposable {
  final CoreStatesHandler _statesHandler;
  final AuthenticationWithCredentials _authenticationWithCredentials;

  LoginBloc(this._statesHandler, this._authenticationWithCredentials)
      : super(IdleState()) {
    on<AuthenticationWithCredentialsEvent>(
      _onAuthenticationWithCredentialsEvent,
    );
  }

  Future<void> _onAuthenticationWithCredentialsEvent(
    AuthenticationWithCredentialsEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(AuthenticatingUserState());

    final parameters = AuthenticationWithCredentialsParameters(
      email: event.email,
      password: event.password,
    );

    final result = await _authenticationWithCredentials(parameters);

    emit(
      result.fold(
        (failure) {
          switch (failure.runtimeType) {
            case InvalidEmailFailure:
              return InvalidEmailState('The entered email is not valid');
            case InvalidPasswordFailure:
              return InvalidPasswordState('The entered password is not valid');
            case InvalidCredentialsFailure:
              return InvalidCredentialsState('Your credentials are invalid');
            case NoUserFoundFailure:
              return NoUserFoundState(
                'No user were found with these credentials',
              );
            default:
              return _statesHandler.handleFailure(failure);
          }
        },
        (success) => SuccessfullyAuthenticatedUserState(success),
      ),
    );
  }

  @override
  void dispose() => close();
}
