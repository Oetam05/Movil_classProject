import 'dart:convert';
import 'package:f_web_authentication/domain/models/Session.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import '../../../domain/models/session_db.dart';

class UserDataSource {
  final String apiKey = 'q6VG85';

  final Connectivity _connectivity = Connectivity();

  Future<bool> saveScore(Session sesion) async {
    logInfo("Hive, Creating session");
    var hiveBox = Hive.box('session');
    // Obtener el último ID almacenado
    int lastLocalId = hiveBox.values.isEmpty ? 0 : hiveBox.values.last.id;
    var sdb = SessionDb(
      id: lastLocalId + 1,
      user: sesion.user,
      op: sesion.op,
      score: sesion.score,
      corrects: sesion.corrects,
      incorrects: sesion.incorrects,
    );
    hiveBox.add(sdb);
    var connectionStatus = await checkCon();
    if (connectionStatus == ConnectivityResult.wifi ||
        connectionStatus == ConnectivityResult.mobile) {
      logInfo("Web service, Creating session");
      final sesionData = sesion.toJson();
      sesionData["id"] = lastLocalId + 1;
      final response = await http.post(
        Uri.parse("https://retoolapi.dev/$apiKey/data"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(sesionData),
      );

      if (response.statusCode == 201) {
        var key = hiveBox.keys.last;
        sdb.isSynced = true;
        hiveBox.put(key, sdb);
        return Future.value(true);
      } else {
        logError("Got error code ${response.statusCode}");
        return Future.value(false);
      }
    } else {
      logInfo('Sin conexion a internet');
      return Future.value(true);
    }
  }

  Future<int> getHighScore(String op, String user) async {
    int hiveScore = 0;
    List hiveSessions = [];
    hiveSessions = Hive.box('session')
        .values
        .where((s) => s.user == user && s.op == op)
        .toList();
    if (hiveSessions.isNotEmpty) {
      for (final session in hiveSessions) {
        if (session.score > hiveScore) {
          hiveScore = session.score;
        }
      }
    }
    return Future.value(hiveScore);
  }

  Future<ConnectivityResult> checkCon() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      logError(e);
    }
    return result;
  }

  void getApiSessions(String user) async {
    final response = await http.get(
      Uri.parse("https://retoolapi.dev/$apiKey/data?user=$user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        logInfo("Got ${data.length} sessions");
        var hiveBox = Hive.box('session');
        final localSessions =
            hiveBox.values; // Obtén todas las sesiones de Hive
        final Map<int, SessionDb> localSessionsMap = Map.fromIterable(
          localSessions,
          key: (session) => session.id,
        );
        for (final apiSession in data) {
          final localSession = localSessionsMap[apiSession["id"]];
          if (localSession == null) {
            // La sesión de la API no está en Hive, así que la almacenamos.
            var sdb = SessionDb(
                user: apiSession["user"],
                op: apiSession["op"],
                score: apiSession["score"],
                corrects: apiSession["corrects"].cast<String>(),
                incorrects: apiSession["incorrects"].cast<String>(),
                id: apiSession["id"]);
            sdb.isSynced = true;
            await hiveBox.add(sdb);
          }
        }
      } else {
        logInfo("No sessions found");
      }
    } else {
      logError("Got error code ${response.statusCode}");
    }
  }

  void sendLocalSessions(String user) async {
    var connectionStatus = await checkCon();
    if (connectionStatus == ConnectivityResult.wifi ||
        connectionStatus == ConnectivityResult.mobile) {
      var hiveBox = Hive.box('session');
      final localSessions =
          hiveBox.values.where((s) => !s.isSynced && s.user == user).toList();
      if (localSessions.isNotEmpty) {
        logInfo("Sending ${localSessions.length} sessions");
        for (final session in localSessions) {
          final sesionData = {
            "id": session.id,
            "user": session.user,
            "op": session.op,
            "score": session.score,
            "corrects": session.corrects,
            "incorrects": session.incorrects,
          };
          final response = http.post(
            Uri.parse("https://retoolapi.dev/$apiKey/data"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(sesionData),
          );
          response.then((value) {
            if (value.statusCode == 201) {
              session.isSynced = true;
              hiveBox.put(session.key, session);
              logInfo("after send id: ${session.id} ${hiveBox.get(session.key).isSynced}");
            } else {
              logError("Got error code ${value.statusCode}");
            }
          });
        }
      } else {
        logInfo("No sessions to send");
      }
    }
  }
}
