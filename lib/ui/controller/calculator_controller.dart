import 'package:f_web_authentication/domain/use_case/calculator_usecase.dart';
import 'package:get/get.dart';

class CalculatorController extends GetxController {
  var userInput = ''.obs;
  var score = 0;
  String op = "";
  int i = 0;
  int dificulty = 0;
  final CalculatorUseCase calculatorUseCase = Get.find();
  String generateRandomNumbers() {
    if (score > 0 && score < 200) {
      dificulty = 1;
    } else if (score >= 200 && score < 400) {
      dificulty = 2;
    } else if (score >= 400) {
      dificulty = 3;
    }
    if (op.length == 1) {
      if (i < 6) {
        i++;
        return calculatorUseCase.generateRandomNumbers(dificulty, op);
      } else {
        calculatorUseCase.saveScore(score);
        return "Game Over \n Score: $score";
      }
    } else {
      if (i < 3) {
        i++;
        return calculatorUseCase.generateRandomNumbers(
            dificulty, op.substring(0, 1));
      } else if (i < 6 && i >= 3) {
        i++;
        return calculatorUseCase.generateRandomNumbers(
            dificulty, op.substring(1));
      } else {
        return "Game Over \n Score: $score";
      }
    }
  }

  void reset() {
    score = 0;
    i = 0;
  }

  int finish() {
    return i;
  }

  void setOp(String op) {
    this.op = op;
  }

  void calculate(String question, int time) {
    score += calculatorUseCase.calculate(question, userInput.value, time);
  }

  void addToInput(String value) {
    userInput.value += value;
  }

  void clearInput() {
    userInput.value = '';
  }
}
