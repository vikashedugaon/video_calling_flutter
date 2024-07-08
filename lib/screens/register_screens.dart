

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_calling_flutter/app_extentions.dart';

import '../controllers/auth_controller.dart';
import '../controllers/connection_controller.dart';
import '../utils.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import 'connections_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ConnectionController connectionController = Get.put(ConnectionController());
  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      bottomNavigationBar: FormButton(
          buttonText: "Register",
          color: Colors.blue,
          onTap: () async {
            if(_formKey.currentState!.validate()){
              await authController
                  .createUser(
                  email: emailController.text,
                  password: passwordController.text,
                  name: nameController.text)
                  .whenComplete(() {
                withoutBack(context: context, screen: ConnectionsScreen());})
                  .catchError((e) => Get.showSnackbar(GetSnackBar(
                message: e.toString(),
              )));
            }
          },
          width: context.screenWidth() * 0.8),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
                width: context.screenWidth() * .5,
                height: context.screenHeight() * .3,
                child: FittedBox(child: Image.asset("images/8021827.png"))),
          ),
          Expanded(
            flex: 4,
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: context.screenHeight() * 0.05,
                      ),
                      InputField(
                        label: "Enter Your Name",
                        controller: nameController,
                        horizontalPadding: context.screenWidth() * 0.05,
                        type: TextInputType.name,
                      ),
                      SizedBox(
                        height: context.screenHeight() * 0.05,
                      ),
                      InputField(
                        label: "Enter Your Email",
                        controller: emailController,
                        horizontalPadding: context.screenWidth() * 0.05,
                        type: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: context.screenHeight() * 0.05,
                      ),
                      InputField(
                        label: "Enter Your Password",
                        controller: passwordController,
                        horizontalPadding: context.screenWidth() * 0.05,
                        type: TextInputType.visiblePassword,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          TextButton(
                              onPressed: () {
                                withoutBack(
                                    context: context, screen: LoginScreen());
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: context.screenHeight() * 0.08,
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
