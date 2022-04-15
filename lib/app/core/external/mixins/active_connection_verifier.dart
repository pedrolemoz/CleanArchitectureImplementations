import 'dart:io';

mixin ActiveNetworkVerifier {
  Future<bool> get hasActiveNetwork async {
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
