import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InitializationPage extends StatelessWidget {
  const InitializationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Implementations'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Choose a module to navigate'),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Authentication'),
                  onPressed: () {
                    Modular.to.pushNamed('/authentication');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
