import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:gixatapp/controllers/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Rxn<User> user = Rxn<User>();
  Rx<Map<String, dynamic>?> userData = Rx<Map<String, dynamic>?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> refreshUserData() async {
    try {
      final String uid = _auth.currentUser!.uid;

      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData.value = userDoc.data()!;
      } else {
        Get.snackbar("Error", "User data not found in Firestore.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e");
    }
  }

  Future<void> saveTokens() async {
    try {
      final String? fcmToken = await _firebaseMessaging.getToken();
      final String uid = _auth.currentUser!.uid;

      // For iOS, fetch the APNs token
      String? apnsToken;
      if (GetPlatform.isIOS) {
        apnsToken = await _firebaseMessaging.getAPNSToken();
      }

      if (fcmToken != null) {
        await db.collection('users').doc(uid).update({
          'fcmToken': fcmToken,
          if (apnsToken != null) 'apnsToken': apnsToken,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save tokens: $e");
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final String uid = _auth.currentUser!.uid;

      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData.value = userDoc.data()!;
        await saveTokens(); // Save FCM and APNs tokens after login
        Get.toNamed('/home');
      } else {
        Get.toNamed('/completeProfile');
      }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final String uid = userCredential.user!.uid;

      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData.value = userDoc.data()!;
        await saveTokens(); // Save FCM and APNs tokens after Google sign-in
        Get.toNamed('/home');
      } else {
        Get.toNamed('/completeProfile');
      }
    } catch (e) {
      Get.snackbar(
        "Sign-In Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    try {
      final String uid = _auth.currentUser!.uid;
      await db.collection('users').doc(uid).update(updatedData);
      userData.value = updatedData;
      Get.snackbar("Success", "Profile updated successfully.",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final String uid = _auth.currentUser!.uid;
      await db.collection('users').doc(uid).delete();
      await _auth.currentUser!.delete();
      Get.toNamed('/auth');
      Get.snackbar("Account Deleted", "Your account has been deleted.",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.toNamed('/auth');
  }

  Future<void> signInWithApple() async {
    try {
      // Request an Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuth credential for Firebase
      final OAuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Use the credential to sign in to Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Optionally fetch user data from Firestore or update as needed
      final String uid = userCredential.user!.uid;
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData.value = userDoc.data()!;
        await saveTokens();
        Get.toNamed('/home');
      } else {
        Get.toNamed('/completeProfile');
      }
    } catch (e) {
      logPrint.e(
        "Error during Apple Sign-In",
        error: e,
      );
    }
  }
}
