import 'package:get/get.dart';
import 'dart:math';
//import '../models/user.dart';
import '../repositories/repository.dart';

class CalculatorUseCase {
  final Repository _repository = Get.find();
  List<String> corrects = [];
  List<String> incorrects = [];
  CalculatorUseCase();

  String generateRandomNumbers(int difficulty, String op) {
    final random = Random();

    int random1;
    int random2;
    switch (difficulty) {
      case 1:
        random1 = random.nextInt(9)+1; // Número aleatorio de 1 a 9
        random2 = random.nextInt(9)+1; // Número aleatorio de 1 a 9
        break;
      case 2:
        random1 = random.nextInt(90) + 10; // Número aleatorio de 10 a 99
        random2 = random.nextInt(9) + 1; // Número aleatorio de 1 a 9
        break;
      case 3:
        random1 = random.nextInt(90) + 10; // Número aleatorio de 10 a 99
        random2 = random.nextInt(90) + 10; // Número aleatorio de 10 a 99
        break;
      default:
        // Por defecto, genera números de un dígito
        random1 = random.nextInt(10); // Número aleatorio de 0 a 9
        random2 = random.nextInt(10); // Número aleatorio de 0 a 9
        break;
    }
    String question = '$random1 $op $random2';
    return question;
  }

  void calculate(String question, String answer) {
    final q = question.split(' ');
    final n1 = int.parse(q[0]);
    final op = q[1];
    final n2 = int.parse(q[2]);
    int correct = 0;
    if (op == '+') {
      correct = n1 + n2;
    } else if (op == '-') {
      correct = n1 - n2;
    } else if (op == '*') {
      correct = n1 * n2;
    }
    if (answer == correct.toString()) {
      corrects.add(question);
    } else {
      incorrects.add(question);
    }
  }
}
