import 'package:f_web_authentication/domain/models/Session.dart';
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
        random1 = random.nextInt(9) + 1; // Número aleatorio de 1 a 9
        random2 = random.nextInt(9) + 1; // Número aleatorio de 1 a 9
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
        random1 = random.nextInt(9) + 1; // Número aleatorio de 0 a 9
        random2 = random.nextInt(9) + 1; // Número aleatorio de 0 a 9
        break;
    }
    String question = random1 > random2
        ? '¿Cuánto es $random1 $op $random2 ?'
        : '¿Cuánto es $random2 $op $random1 ?';
    return question;
  }

  int calculate(String question, String answer, int time) {
    final q = question.split(' ');
    final n1 = int.parse(q[2]);
    final op = q[3];
    final n2 = int.parse(q[4]);
    var score = 0;
    int correct = 0;
    if (op == '+') {
      correct = n1 + n2;
    } else if (op == '-') {
      correct = n1 - n2;
    } else if (op == '*') {
      correct = n1 * n2;
    }

    if (answer == correct.toString()) {
      corrects.add('$question=$answer');
      score = (201 / (time + 1) + 100) ~/ 1;
    } else {
      incorrects.add('$question=$correct you sent $answer');
      score = -100;
    }
    return score;
  }

  void saveScore(int score) {
    Session sesion =
        Session(score: score, corrects: corrects, incorrects: incorrects);
    _repository.saveScore(sesion);
  }
}
