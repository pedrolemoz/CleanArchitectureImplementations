import 'package:magnet_ui/magnet_ui.dart';

import '../../../domain/errors/failure.dart';
import '../../../domain/errors/global_failures.dart';
import 'core_states_handler.dart';
import 'global_states.dart';

class CoreStatesHandlerImplementation implements CoreStatesHandler {
  @override
  AppState handleFailure(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return ServerErrorState();
      case NoInternetConnectionFailure:
        return NoInternetConnectionState();
      case UnableToGetUserDataFailure:
        return UnableToGetUserDataState();
      default:
        return UnknownState(failure.message);
    }
  }
}
