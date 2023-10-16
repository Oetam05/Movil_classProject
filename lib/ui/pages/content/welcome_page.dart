import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
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
  CalculatorController calculatorController = Get.find();
  var highScoreSuma = 0.obs;
  var highScoreResta = 0.obs;
  var highScoreSumaResta = 0.obs;
  var highScoreMultiplicacion = 0.obs;
  @override
  void initState() {
    super.initState();
    // if (!authenticationController.isLogged) Get.off(() => const LoginPage());
    getHighScores();
  }

  void getHighScores() async {
    highScoreSuma.value = await calculatorController.getHighScore("+");
    highScoreResta.value = await calculatorController.getHighScore("-");
    highScoreSumaResta.value = await calculatorController.getHighScore("+-");
    highScoreMultiplicacion.value =
        await calculatorController.getHighScore("*");
  }

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
      Get.off(() => const LoginPage());
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('playButton'),
              onPressed: () {
                Get.off(
                  () => const PlayingPage(),
                  arguments: optionsMap[selectedOp],
                );
              },
              child: const Text('¡Jugar!'),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Center(
                child: Text(
                  "HighScore:${selectedOp == 'Suma' ? highScoreSuma.value : selectedOp == 'Resta' ? highScoreResta.value : selectedOp == 'Suma y Resta' ? highScoreSumaResta.value : highScoreMultiplicacion.value}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
