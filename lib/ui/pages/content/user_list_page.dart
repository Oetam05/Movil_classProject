import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../controller/authentication_controller.dart';
import '../../controller/user_controller.dart';
import '../../controller/calculator_controller.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  UserController userController = Get.find();
  AuthenticationController authenticationController = Get.find();
  final CalculatorController calculatorController =
      Get.put(CalculatorController());

  _logout() async {
    try {
      await authenticationController.logOut();
    } catch (e) {
      logInfo(e);
    }
  }

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
                  onTap: () {
                    if (numero == 10) {
                      calculatorController.clearInput();
                    } else if (numero == 11) {
                      calculatorController.addToInput('0');
                    } else if (numero == 12) {
                      // Lógica para el botón 'GO'
                    } else {
                      calculatorController.addToInput('$numero');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      numero == 10
                          ? 'C'
                          : numero == 11
                              ? '0'
                              : numero == 12
                                  ? 'GO'
                                  : '$numero',
                      style: const TextStyle(fontSize: 24.0),
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
