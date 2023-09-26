import 'package:f_web_authentication/domain/use_case/calculator_usecase.dart';
import 'package:get/get.dart';

class CalculatorController extends GetxController {
  var userInput = ''.obs;
  String op = "";

  final CalculatorUseCase calculatorUseCase = Get.find();
  String generateRandomNumbers() {
    return calculatorUseCase.generateRandomNumbers(1, op);
  }
  void setOp(String op){
    this.op = op;
  }
  void calculate(String question) {
    calculatorUseCase.calculate(question, userInput.value);
  }

  void addToInput(String value) {
    userInput.value += value;
  }

  void clearInput() {
    userInput.value = '';
  }
}
