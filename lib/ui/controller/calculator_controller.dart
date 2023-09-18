import 'package:get/get.dart';
import 'dart:math';

class CalculatorController extends GetxController {
  var userInput = ''.obs;
  var random1 = 0.obs;
  var random2 = 0.obs;

  void generateRandomNumbers() {
    final random = Random();
    random1.value = random.nextInt(10); 
    random2.value = random.nextInt(10);
  }

  int calculateSum() {
    return random1.value + random2.value;
  }

  void addToInput(String value) {
    userInput.value += value;
  }

  void clearInput() {
    userInput.value = '';
  }
}
