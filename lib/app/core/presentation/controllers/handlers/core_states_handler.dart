import 'package:magnet_ui/magnet_ui.dart';

import '../../../domain/errors/failure.dart';

abstract class CoreStatesHandler {
  AppState handleFailure(Failure failure);
}
