import 'package:f_web_authentication/data/datasources/remote/authentication_datasource.dart';
import 'package:f_web_authentication/domain/models/Session.dart';

import '../../data/datasources/remote/user_datasource.dart';

class Repository {
  late AuthenticationDatatasource _authenticationDataSource;
  late UserDataSource _userDatatasource;
  String token = "";
  String user = "default_user";
  String get getToken => token;
  // the base url of the API should end without the /
  final String _baseUrl =
      'http://ip172-18-0-12-cklh684snmng00fm2pug-8000.direct.labs.play-with-docker.com';

  Repository() {
    _authenticationDataSource = AuthenticationDatatasource();
    _userDatatasource = UserDataSource();
  }

  Future<bool> login(String email, String password) async {
    token = await _authenticationDataSource.login(_baseUrl, email, password);
    user = email;
    return true;
  }

  Future<bool> signUp(String email, String password, String school,
          String birthdate, String grade) async =>
      await _authenticationDataSource.signUp(
          _baseUrl, email, password, school, birthdate, grade);

  Future<bool> logOut() async => await _authenticationDataSource.logOut();

  Future<bool> saveScore(Session sesion) async =>
      await _userDatatasource.saveScore(sesion, user);

  Future<int> getHighScore(String op) async {
    return _userDatatasource.getHighScore(op, user);
  }
}
