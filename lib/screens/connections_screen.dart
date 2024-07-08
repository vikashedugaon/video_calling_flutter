

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_calling_flutter/app_extentions.dart';

import '../controllers/auth_controller.dart';
import '../model/user_model.dart';
import '../services/firebase_services.dart';
import '../widgets/connections_design.dart';
import 'login_screen.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  final AuthController authController =
  Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Connections"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              FutureBuilder(
                future: FirebaseServices.getCurrentUser(FirebaseAuth.instance.currentUser?.uid??""),
                builder: (context, snapshot) => UserAccountsDrawerHeader(
                    accountName: Text(snapshot.data?.name ?? "Name"),
                    accountEmail: Text((snapshot.data?.userName ?? "Email"))),
              ),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => FirebaseServices.auth.signOut().then((value) {
                    authController.onUserLogout();
                    Get.offAll(() => LoginScreen());
                  }))
            ],
          ),
        ),
        body: StreamBuilder<List<UserModel>>(
          stream: FirebaseServices.getAllUsersStream(),
          // Replace with your actual stream function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                    'No users found.'),
              ); // Display a message if no users are available
            } else {
              // Display your UI components using the user data (snapshot.data)
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  if (FirebaseServices().userId != user.userID) {
                    return ConnectionDesign(
                        space: context.screenWidth() * 0.03,
                        model: user,
                        onCallFinished: authController.onSendCallInvitationFinished
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            }
          },
        ));
  }
}
