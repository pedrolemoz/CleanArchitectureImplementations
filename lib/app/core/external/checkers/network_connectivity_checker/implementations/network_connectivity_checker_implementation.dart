import 'dart:io';

import '../abstractions/network_connectivity_checker.dart';

class NetworkConnectivityCheckerImplementation
    implements NetworkConnectivityChecker {
  @override
  Future<bool> hasActiveNetwork() async {
    try {
      await Socket.connect(
        '1.1.1.1',
        53,
        timeout: const Duration(milliseconds: 999),
      );
      return true;
    } catch (exception) {
      return false;
    }
  }
}
