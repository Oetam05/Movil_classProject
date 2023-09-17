import 'package:get/get.dart';

class CalculatorController extends GetxController {
  var userInput = ''.obs;

  void addToInput(String value) {
    userInput.value += value;
  }

  void clearInput() {
    userInput.value = '';
  }
}
