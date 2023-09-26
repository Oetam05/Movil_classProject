import 'package:f_web_authentication/ui/pages/content/playing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Map<String, String> optionsMap = {
    'Suma': '+',
    'Resta': '-',
    'Suma y Resta': '+-',
    'Multiplicación': '*',
  };
  String selectedOp = 'Suma'; // Valor inicial del ComboBox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Seleccione la operación', // Puedes reemplazar esto con tu lógica real
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
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
              onPressed: () {
                print(optionsMap[selectedOp]);

                Get.to(
                  () => const PlayingPage(),
                  arguments: optionsMap[selectedOp], // Aquí pasas el nivel de dificultad
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
