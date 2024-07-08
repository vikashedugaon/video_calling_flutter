

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../model/user_model.dart';
import '../services/firebase_services.dart';

class AuthController extends GetxController{
  Future<bool> loginUser(
      {required String email, required String password}) async {
    UserCredential? userCredential =
    await FirebaseServices.signIn(email: email, password: password);
    onUserLogin(userCredential?.user?.uid ?? "", email);
    return userCredential != null ? true : false;
  }

  Future<void> createUser(
      {required String email,
        required String password,
        required String name}) async {
    try {
      UserCredential? userCredential =
      await FirebaseServices.signUp(email: email, password: password);
      UserModel userModel = UserModel(
          userName: email,
          name: name,
          password: password,
          userID: userCredential?.user!.uid);
      await FirebaseServices.insertUser(user: userModel);
      onUserLogin(userCredential?.user?.uid ?? "", email);
    } on Exception catch (e) {
      log(e.toString());
    }
  }
  void onUserLogout() {
    /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  void onUserLogin(String id, String name) {
    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    if (!ZegoUIKitPrebuiltCallInvitationService().isInit) {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1283349688 /*input your AppID*/,
        appSign:
        "f8553bfbce3a488a41efe47dd3d56fdca4435c72fffd320d5b1ef3f7d1236548" /*input your AppSign*/,
        userID: id,
        userName: name,
        plugins: [ZegoUIKitSignalingPlugin()],
        notificationConfig: ZegoCallInvitationNotificationConfig(
          androidNotificationConfig: ZegoCallAndroidNotificationConfig(
            showFullScreen: true,
            channelID: "zego_call",
            channelName: "Call Notifications",
            sound: "call",
            icon: "call",
          ),
          iOSNotificationConfig: ZegoCallIOSNotificationConfig(
            systemCallingIconName: 'CallKitIcon',
          ),
        ),
        requireConfig: (ZegoCallInvitationData data) {
          final config = (data.invitees.length > 1)
              ? ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
              : ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

          /// support minimizing, show minimizing button
          config.topMenuBar.isVisible = true;
          config.topMenuBar.buttons
              .insert(0, ZegoCallMenuBarButtonName.minimizingButton);

          return config;
        },
      );
    }
  }

  void onSendCallInvitationFinished(
      String code,
      String message,
      List<String> errorInvitees,
      ) {
    if (errorInvitees.isNotEmpty) {
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        var userID = errorInvitees.elementAt(index);
        userIDs += userID + ' ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = 'User doesn\'t exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      Get.showSnackbar(GetSnackBar(
        message: message,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      ));
    } else if (code.isNotEmpty) {
      Get.showSnackbar(GetSnackBar(
          message: 'code: $code, message:$message',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2)));
    }
  }
}