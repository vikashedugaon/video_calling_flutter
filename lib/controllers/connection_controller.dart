

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/user_model.dart';
import '../services/firebase_services.dart';

class ConnectionController extends GetxController {
  RxBool isLogin = false.obs;
  UserModel? userModel;
  @override
  void onInit() {
    isLogin.value = FirebaseServices().user != null ? true : false;
    FirebaseServices.getCurrentUser(FirebaseAuth.instance.currentUser?.uid??"").then((value) => userModel=value! as UserModel?);
    super.onInit();
  }




}
