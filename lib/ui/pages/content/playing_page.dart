import 'package:f_web_authentication/ui/pages/content/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../../controller/authentication_controller.dart';
import '../../controller/calculator_controller.dart';

class PlayingPage extends StatefulWidget {
  const PlayingPage({super.key});
  @override
  State<PlayingPage> createState() => _PlayingPageState();
}

List<Icon> getStars(String difficulty) {
  int stars = int.parse(difficulty);

  return List.generate(stars, (_) {
    return const Icon(
      Icons.star,
      size: 32,
      color: Colors.yellow,
    );
  });
}

class _PlayingPageState extends State<PlayingPage> {
  AuthenticationController authenticationController = Get.find();
  final CalculatorController calculatorController = Get.find();
  String question = "";
  int finish = 0;
  var difficulty = '1';
  var stars = getStars("1");
  var cadena = "";
  @override
  void initState() {
    super.initState();
    final operation = Get.arguments as String;
    calculatorController.setOp(operation);

    cadena = calculatorController
        .generateRandomNumbers(); // Genera nuevos números aleatorios cuando entras a la pantalla
    difficulty = (cadena.split('\t')[2]);
    question = cadena.split('\n')[0];
    calculatorController.clearInput();
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
    DateTime momentoGeneracion = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Column(
        key: const Key('bodyColumn'),
        children: [
          Padding(
            key: const Key('difficultyPadding'),
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              const Text(
                'Dificultad: \t\t\t',
                key: Key('difficultyText'),
                style: TextStyle(fontSize: 24.0),
              ),
              Row(
                children: stars,
              ),
            ]),
          ),
          Padding(
            key: const Key('questionPadding'),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              question.substring(0, question.length - 1),
              key: const Key('questionText'),
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          Padding(
            key: const Key('inputPadding'),
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Text(
                  calculatorController.userInput.value,
                  key: const Key('inputText'),
                  style: const TextStyle(fontSize: 24.0),
                )),
          ),
          Expanded(
            key: const Key('gridView'),
            child: GridView.builder(
              key: const Key('grid'),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columnas en la cuadrícula
              ),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                final numero = index + 1;
                return GestureDetector(
                  key: Key('button_$numero'),
                  onTap: () {},
                  child: ElevatedButton(
                    key: Key('elevatedButton_$numero'),
                    style: buttonStyle, // Aplica el estilo personalizado
                    onPressed: () {
                      // Agrega la lógica de escritura en el campo de texto
                      if (numero == 10) {
                        calculatorController.clearInput();
                      } else if (numero == 11) {
                        calculatorController.addToInput('0');
                      } else if (numero == 12) {
                        // Lógica para el botón 'GO'

                        if (finish < 6) {
                          DateTime momentoRespuesta = DateTime.now();
                          Duration tiempoTranscurrido =
                              momentoRespuesta.difference(momentoGeneracion);
                          calculatorController.calculate(
                              cadena, tiempoTranscurrido.inSeconds);
                          finish = calculatorController.finish();
                          setState(() {
                            cadena =
                                calculatorController.generateRandomNumbers();
                            difficulty = finish < 5
                                ? (cadena.split('\t')[2])
                                : difficulty;
                            stars = getStars(difficulty);
                            question =
                                finish < 6 ? cadena.split('\n')[0] : cadena;
                          });
                        } else {
                          // Si ya se han generado 6 preguntas, se termina el juego
                          Get.off(() => const WelcomePage());
                          calculatorController.reset();
                        }
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
