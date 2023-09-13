import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../../domain/models/user.dart';
import '../../controller/authentication_controller.dart';
import '../../controller/user_controller.dart';
import 'new_user_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  UserController userController = Get.find();
  AuthenticationController authenticationController = Get.find();

  TextEditingController userInputController = TextEditingController();
  String selectedNumbers = '';

  _logout() async {
    try {
      await authenticationController.logOut();
    } catch (e) {
      logInfo(e);
    }
  }

  void _addToSelectedNumbers(String number) {
    setState(() {
      selectedNumbers += number;
      userInputController.text = selectedNumbers;
    });
  }

  @override
  void dispose() {
    userInputController.dispose();
    super.dispose();
  }

  void _clearSelectedNumbers() {
    setState(() {
      selectedNumbers = '';
      userInputController.clear(); // Borra el contenido del campo de texto.
    });
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
            child: TextField(
              controller: userInputController,
              readOnly: true, // Para evitar que el usuario edite el campo
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Respuesta',
              ),
            ),
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
                      _clearSelectedNumbers();
                    } else if (numero == 11) {
                      _addToSelectedNumbers('0');
                    } else if (numero == 12) {
                      // Lógica para el botón 'GO'
                    } else {
                      _addToSelectedNumbers('$numero');
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
