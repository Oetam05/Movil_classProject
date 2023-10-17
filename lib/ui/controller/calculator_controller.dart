import 'package:f_web_authentication/domain/use_case/calculator_usecase.dart';
import 'package:get/get.dart';

class CalculatorController extends GetxController {
  var userInput = ''.obs;
  var score = 0;
  String op = "";
  int i = 0;
  int difficulty = 1;
  final CalculatorUseCase calculatorUseCase = Get.find();
  String generateRandomNumbers() {
    if (score > 0 && score < 200) {
      difficulty = 1;
    } else if (score >= 200 && score < 400) {
      difficulty = 2;
    } else if (score >= 400) {
      difficulty = 3;
    }
    if (op.length == 1) {
      if (i < 6) {
        i++;
        return '${calculatorUseCase.generateRandomNumbers(difficulty, op)} \nScore:\t$score \t$difficulty';
      } else {
        calculatorUseCase.saveScore(score, op);
        return "Game Over \n Score: $score \t$difficulty";
      }
    } else {
      if (i < 3) {
        i++;
        return '${calculatorUseCase.generateRandomNumbers(difficulty, op.substring(0, 1))}\nScore:\t$score \t$difficulty';
      } else if (i < 6 && i >= 3) {
        i++;
        return '${calculatorUseCase.generateRandomNumbers(difficulty, op.substring(1))}\nScore:\t$score \t$difficulty';
      } else {
        calculatorUseCase.saveScore(score, op);
        return "Game Over \n Score: $score \t$difficulty";
      }
    }
  }

  Future<int> getHighScore(String op) async {
    return calculatorUseCase.getHighScore(op);
  }

  void reset() {
    score = 0;
    i = 0;
    difficulty = 0;
  }

  int finish() {
    return i;
  }

  void setOp(String op) {
    this.op = op;
  }

  void calculate(String question, int time) {
    score += calculatorUseCase.calculate(question, userInput.value, time);
    if (score < 0) {
      score = 0;
    }
  }

  void addToInput(String value) {
    userInput.value += value;
  }

  void clearInput() {
    userInput.value = '';
  }
}
