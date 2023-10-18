import 'package:f_web_authentication/domain/use_case/authentication_usecase.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final logged = false.obs;
  String token = "";
  bool get isLogged => logged.value;
  final AuthenticationUseCase authentication = Get.find();

  @override
  void onInit() async{
    super.onInit();
    await getPreferences();
  }

  getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    logged.value = prefs.getBool('logged') ?? false;
    if (logged.value) {
      authentication.setUser(prefs.getString('user') ?? "default_user");
    }
  }

  Future<void> login(email, password) async {
    await authentication.login(email, password);
    token = authentication.getToken();
    logged.value = true;
    saveLogin();
  }

  Future<void> saveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', true);
  }

  Future<bool> signUp(email, password, school, birthdate, grade) async {
    final AuthenticationUseCase authentication = Get.find();
    logInfo('Controller Sign Up');
    await authentication.signUp(email, password, school, birthdate, grade);
    return true;
  }

  Future<void> logOut() async {
    logged.value = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', false);
    await authentication.logOut();
  }
}
