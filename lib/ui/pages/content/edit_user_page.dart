import 'package:f_web_authentication/domain/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';

class EditUserPage extends StatefulWidget {
  final String token;
  const EditUserPage({super.key, required this.token});
  
  @override
  State<EditUserPage> createState() => _EditUserPageState();
  
}

class _EditUserPageState extends State<EditUserPage> {
  final controllerschool = TextEditingController();
  final controllerbirthdate = TextEditingController();
  final controllergrade = TextEditingController();
  String em="";

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    controllerschool.text = "user.school";
    controllerbirthdate.text = "user.birthdate";
    controllergrade.text = "user.email";
    return Scaffold(
      appBar: AppBar(
        title: Text("${"user.school"} ${"user.birthdate"}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
                controller: controllerschool,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                )),
            const SizedBox(
              height: 20,
            ),
            TextField(
                controller: controllerbirthdate,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                )),
            const SizedBox(
              height: 20,
            ),
            TextField(
                controller: controllergrade,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Grade',
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      flex: 2,
                      child: ElevatedButton(
                          onPressed: () async {
                            await userController.updateUser(User(
                                email: em,
                                grade: controllergrade.text,
                                school: controllerschool.text,
                                birthdate: controllerbirthdate.text))
                                ;
                            Get.back();
                          },
                          child: const Text("Update")))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
