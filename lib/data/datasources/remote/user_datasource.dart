import 'dart:convert';
import 'package:f_web_authentication/domain/models/Session.dart';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;

class UserDataSource {
  final String apiKey = 'q6VG85';

  Future<bool> saveScore(Session sesion, String user) async {
    logInfo("Web service, Adding user");
    final sesionData = sesion.toJson();
    sesionData["user"] = user;
    final response = await http.post(
      Uri.parse("https://retoolapi.dev/$apiKey/data"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sesionData),
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
    final response = await http.get(
      Uri.parse("https://retoolapi.dev/$apiKey/data?_sort=score&_order=desc&user=$user&op=$op"),
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
