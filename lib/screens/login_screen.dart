

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_calling_flutter/app_extentions.dart';
import 'package:video_calling_flutter/screens/register_screens.dart';

import '../controllers/auth_controller.dart';
import '../controllers/connection_controller.dart';
import '../utils.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import 'connections_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ConnectionController connectionController = Get.put(ConnectionController());
  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      bottomNavigationBar: FormButton(
          buttonText: "Login",
          color: Colors.blue,
          onTap: () async{
            if(_formKey.currentState!.validate()){
              bool status =  await authController.loginUser(email: emailController.text, password: passwordController.text);
              if(status){

                Get.to(()=> const ConnectionsScreen());
              }else{
                Get.showSnackbar(const GetSnackBar(message: "Something went wrong",duration: Duration(seconds: 2),));
              }
            }
          },
          width: context.screenWidth() * 0.8),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
                width: context.screenWidth() * .8,
                height: context.screenHeight() * .4,
                child: FittedBox(child: Image.asset("images/8021827.png"))),
          ),
          Expanded(
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
                          Text("Don't have an account?"),
                          TextButton(
                              onPressed: () {
                                withoutBack(
                                    context: context, screen: RegisterScreen());
                              },
                              child: Text(
                                "Register",
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
