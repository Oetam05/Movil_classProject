import 'package:get/get.dart';
import 'dart:math';

class CalculatorController extends GetxController {
  var userInput = ''.obs;
  int random1 = 0;
  int random2 = 0;
  String op = "+";
  var question = ''.obs;

  int i = 0;
  int ga = 0;
  void generateRandomNumbers() {
    final random = Random();

    random1 = random.nextInt(10);
    random2 = random.nextInt(10);
    question.value = '¿Cuánto es $random1 + $random2?';
  }

  void calculate() {
    if (random1 + random2 == int.tryParse(userInput.value)) {
      ga++;
      print(ga);
    }
    i++;
    if (i < 6) {
      generateRandomNumbers();
    } else {
      print("se acab'o");
    }
  }

  void addToInput(String value) {
    userInput.value += value;
  }

  void clearInput() {
    userInput.value = '';
  }
}
