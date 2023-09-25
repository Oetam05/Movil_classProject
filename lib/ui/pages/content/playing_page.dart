import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../controller/authentication_controller.dart';
import '../../controller/user_controller.dart';
import '../../controller/calculator_controller.dart';

class PlayingPage extends StatefulWidget {
  const PlayingPage({super.key});

  @override
  State<PlayingPage> createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {
  UserController userController = Get.find();
  AuthenticationController authenticationController = Get.find();
  final CalculatorController calculatorController =
      Get.put(CalculatorController());

  @override
  void initState() {
    super.initState();
    calculatorController
        .generateRandomNumbers(); // Genera nuevos números aleatorios cada vez que entras a la pantalla
    calculatorController.clearInput();
  }

  _logout() async {
    try {
      await authenticationController.logOut();
    } catch (e) {
      logInfo(e);
    }
  }

  final buttonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(60.0), // Radio de borde (20.0 para redondear)
    ),
    textStyle: const TextStyle(fontSize: 24.0), // Tamaño del texto
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome"), actions: [
        IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _logout();
            }),
        IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () {
              userController.simulateProcess();
            }),
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Text(
                  '${calculatorController.question.value} ',
                  style: const TextStyle(fontSize: 24.0),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Text(
                  calculatorController.userInput.value,
                  style: const TextStyle(fontSize: 24.0),
                )),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columnas en la cuadrícula
              ),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                final numero = index + 1;
                return GestureDetector(
                  onTap: () {},
                  child: ElevatedButton(
                    style: buttonStyle, // Aplica el estilo personalizado
                    onPressed: () {
                      // Agrega la lógica de escritura en el campo de texto
                      if (numero == 10) {
                        calculatorController.clearInput();
                      } else if (numero == 11) {
                        calculatorController.addToInput('0');
                      } else if (numero == 12) {
                        // Lógica para el botón 'GO'
                        calculatorController.calculate();
                        // Limpia la entrada
                        calculatorController.clearInput();
                      } else {
                        calculatorController.addToInput('$numero');
                      }
                    },
                    child: Text(
                      numero == 10
                          ? 'C'
                          : numero == 11
                              ? '0'
                              : numero == 12
                                  ? 'GO'
                                  : '$numero',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
