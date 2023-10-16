import 'package:f_web_authentication/domain/use_case/calculator_usecase.dart';
import 'package:f_web_authentication/ui/central.dart';
import 'package:f_web_authentication/ui/controller/authentication_controller.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loggy/loggy.dart';

import 'domain/models/session_db.dart';
import 'domain/repositories/repository.dart';
import 'domain/use_case/authentication_usecase.dart';

Future<List<Box>> _openBox() async {
  List<Box> boxList = [];
  await Hive.initFlutter();
  Hive.registerAdapter(SessionDbAdapter());
  boxList.add(await Hive.openBox('session'));
  return boxList;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _openBox();  
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  Get.put(Repository());
  Get.put(AuthenticationUseCase());
  Get.put(AuthenticationController());
  Get.put(CalculatorUseCase());
  Get.put(CalculatorController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Central(),
    );
  }
}
