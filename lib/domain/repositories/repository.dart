import 'package:f_web_authentication/data/datasources/remote/authentication_datasource.dart';
import 'package:f_web_authentication/domain/models/Session.dart';
import '../../data/datasources/remote/user_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  late AuthenticationDatatasource _authenticationDataSource;
  late UserDataSource _userDatatasource;
  String token = "";
  String user = "default_user";  
  String get getToken => token;
  // the base url of the API should end without the /
  final String _baseUrl =
      'http://ip172-18-0-158-cknpesssnmng008sqec0-8000.direct.labs.play-with-docker.com';

  Repository() {
    _authenticationDataSource = AuthenticationDatatasource();
    _userDatatasource = UserDataSource();
  }

  setUser(String user) {
    this.user = user;
    _userDatatasource.getApiSessions(user);
  }

  Future<bool> login(String email, String password) async {
    token = await _authenticationDataSource.login(_baseUrl, email, password);
    user = email;
    if (token != "") {
      _userDatatasource.getApiSessions(user);
      saveLogin();
    }
    return true;
  }

  Future<void> saveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
  }

  Future<bool> signUp(String email, String password, String school,
          String birthdate, String grade) async =>
      await _authenticationDataSource.signUp(
          _baseUrl, email, password, school, birthdate, grade);

  Future<bool> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', "default_user");
    return Future.value(true);
  }

  Future<bool> saveScore(Session sesion) async =>
      await _userDatatasource.saveScore(sesion);

  Future<int> getHighScore(String op) async {
    return _userDatatasource.getHighScore(op, user);
  }

  void sendLocalSessions() async {
    _userDatatasource.sendLocalSessions(user);
  }
}
