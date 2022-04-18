import 'package:magnet_ui/magnet_ui.dart';

class ServerErrorState implements ErrorState {
  @override
  final String? message;

  ServerErrorState([this.message]);
}

class NoInternetConnectionState implements ErrorState {
  @override
  final String? message;

  NoInternetConnectionState([this.message]);
}

class UnableToGetUserDataState implements ErrorState {
  @override
  final String? message;

  UnableToGetUserDataState([this.message]);
}

class UnknownState implements ErrorState {
  @override
  final String? message;

  UnknownState([this.message]);
}
