import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gixatapp/controllers/auth_controller.dart';
import 'package:gixatapp/controllers/check_update.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _checkAuth(authController), // Perform authentication check
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading spinner
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const SizedBox.shrink(); // Placeholder widget
            }
          },
        ),
      ),
    );
  }

  Future<void> _checkAuth(AuthController authController) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;

    final User? firebaseUser = auth.currentUser;

    // Delay navigation until the build process is complete
    Future.microtask(() async {
      if (firebaseUser != null) {
        // User is logged in, fetch user data
        final String uid = firebaseUser.uid;

        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await db.collection('users').doc(uid).get();

        if (userDoc.exists) {
          // Save user data in AuthController
          authController.userData.value = {"id": uid, ...userDoc.data()!};

          // Navigate to home page
          Get.offAllNamed('/home');
          VersionController().checkForUpdates();
        } else {
          // Navigate to complete profile page
          Get.offAllNamed('/completeProfile');
        }
      } else {
        // User is not logged in, navigate to login page
        Get.offAllNamed('/auth');
      }
    });
  }
}
