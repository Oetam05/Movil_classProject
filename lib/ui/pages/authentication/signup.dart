import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../controller/authentication_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _FirebaseSignUpState();
}

class _FirebaseSignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController(text: 'a@a.com');
  final controllerPassword = TextEditingController(text: '123456');
  final controllerSchool = TextEditingController(text: 'abc');
  final controllerBirthdate = TextEditingController(text: '12/05');
  final controllerGrade = TextEditingController(text: '5');
  AuthenticationController authenticationController = Get.find();

  _signup(theEmail, thePassword, theSchool, theBirthdate, theGrade) async {
    try {
      await authenticationController.signUp(theEmail, thePassword, theSchool, theBirthdate, theGrade);

      Get.snackbar(
        "Sign Up",
        'OK',
        icon: const Icon(Icons.person, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (err) {
      logError('SignUp error $err');
      Get.snackbar(
        "Sign Up",
        err.toString(),
        icon: const Icon(Icons.person, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign Up Information",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: controllerEmail,
                          decoration:
                              const InputDecoration(labelText: "Email address"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              logError('SignUp validation empty email');
                              return "Enter email";
                            } else if (!value.contains('@')) {
                              logError('SignUp validation invalid email');
                              return "Enter valid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: controllerSchool,
                          decoration:
                              const InputDecoration(labelText: "School"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              logError('SignUp validation empty school');
                              return "Enter school";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: controllerBirthdate,
                          decoration:
                              const InputDecoration(labelText: "birthdate"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              logError('SignUp validation empty birthdate');
                              return "Enter email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerGrade,
                          decoration:
                              const InputDecoration(labelText: "Grade"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              logError('SignUp validation empty grade');
                              return "Enter grade";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: controllerPassword,
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter password";
                            } else if (value.length < 6) {
                              return "Password should have at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () async {
                              final form = _formKey.currentState;
                              form!.save();
                              // this line dismiss the keyboard by taking away the focus of the TextFormField and giving it to an unused
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (_formKey.currentState!.validate()) {
                                logInfo('SignUp validation form ok');
                                await _signup(controllerEmail.text,
                                    controllerPassword.text, controllerSchool.text, controllerBirthdate.text, controllerGrade.text);
                              } else {
                                logError('SignUp validation form nok');
                              }
                            },
                            child: const Text("Submit")),
                      ]),
                ))));
  }
}
