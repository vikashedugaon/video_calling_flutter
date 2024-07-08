


import 'package:flutter/cupertino.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key, required this.callID,required this.userId,required this.userName});
  final String callID;
  final String userName;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1283349688, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "f8553bfbce3a488a41efe47dd3d56fdca4435c72fffd320d5b1ef3f7d1236548", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userId,
      userName: userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}

