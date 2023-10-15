import 'dart:convert';
import 'package:f_web_authentication/domain/models/Session.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;

import '../../../domain/models/session_db.dart';

class UserDataSource {
  final String apiKey = 'q6VG85';

  Future<bool> saveScore(Session sesion) async {
    logInfo("Hive, Creating session");
    Hive.box('session').add(SessionDb(
      user: sesion.user,
      op: sesion.op,
      score: sesion.score,
      corrects: sesion.corrects,
      incorrects: sesion.incorrects,
    ));
    logInfo("Web service, Creating session");
    final response = await http.post(
      Uri.parse("https://retoolapi.dev/$apiKey/data"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sesion.toJson()),
    );

    if (response.statusCode == 201) {
      //logInfo(response.body);
      return Future.value(true);
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.value(false);
    }
  }

  Future<int> getHighScore(String op, String user) async {
    Future<int> hiveScore = Future.value(0);
    Future<List<Session>> hiveSessions = Future.value([]);
    hiveSessions = Future.value(Hive.box('session')
        .values
        .map((e) => Session(
            score: e.score,
            corrects: e.corrects,
            incorrects: e.incorrects,
            op: e.op,
            user: e.user))
        .toList());
    hiveSessions.then((value) {
      logInfo("El valor de hiveSessions es: ${value[0].score}");
    });

    final response = await http.get(
      Uri.parse(
          "https://retoolapi.dev/$apiKey/data?_sort=score&_order=desc&user=$user&op=$op"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Future.value(data[0]["score"]);
      } else {
        return Future.value(0);
      }
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.value(0);
    }
  }
}
