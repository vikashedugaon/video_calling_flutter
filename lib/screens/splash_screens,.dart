

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/auth_controller.dart';
import '../controllers/connection_controller.dart';
import '../utils.dart';
import 'connections_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ConnectionController connectionController = Get.put(ConnectionController());
  final AuthController authController = Get.put(AuthController());
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () async{
      if(connectionController.isLogin.value == true){
        authController.onUserLogin(user ?? "", connectionController.userModel?.userName! ?? "");
        withoutBack(context: context, screen: const ConnectionsScreen());
      }else{
        withoutBack(context: context, screen: const LoginScreen());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Face-Chat",style: TextStyle(fontSize: 30,color: Colors.blue),),
            LinearProgressIndicator()
          ],
        ),
      ),
    );
  }
}
