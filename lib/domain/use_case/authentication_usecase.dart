import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:get/get.dart';

class AuthenticationUseCase {
  final Repository _repository = Get.find();

  Future<bool> login(String email, String password) async =>
      await _repository.login(email, password);

  Future<bool> signUp(String email, String password, String school, String birthdate, String grade) async =>
      await _repository.signUp(email, password, school, birthdate, grade);

  Future<bool> logOut() async => await _repository.logOut();
  String getToken() => _repository.getToken;
  void setUser(String user) => _repository.setUser(user);
}
