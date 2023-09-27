import 'package:f_web_authentication/ui/pages/content/playing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../controller/authentication_controller.dart';
import '../authentication/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  AuthenticationController authenticationController = Get.find();

  final Map<String, String> optionsMap = {
    'Suma': '+',
    'Resta': '-',
    'Suma y Resta': '+-',
    'Multiplicación': '*',
  };

  String selectedOp = 'Suma'; // Valor inicial del ComboBox

  void _logout() async {
    try {
      await authenticationController.logOut();
    } catch (e) {
      logInfo(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        actions: [
          IconButton(
              key: const Key('logoutButton'),
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                _logout();
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          key: const Key('bodyColumn'),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Seleccione la operación',
              key: Key('titleText'),
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(key: Key('space1'), height: 20),
            DropdownButton<String>(
              key: const Key('dropdown'),
              value: selectedOp,
              items: optionsMap.keys.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOp = newValue!;
                });
              },
            ),
            const SizedBox(key: Key('space2'), height: 20),
            ElevatedButton(
              key: const Key('playButton'),
              onPressed: () {
                print(optionsMap[selectedOp]);
                Get.to(
                  () => Obx(() => authenticationController.isLogged
                      ? const PlayingPage()
                      : const LoginPage()),
                  arguments: optionsMap[selectedOp],
                );
              },
              child: const Text('¡Jugar!'),
            ),
          ],
        ),
      ),
    );
  }
}
