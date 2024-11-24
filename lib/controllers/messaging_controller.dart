import 'package:gixatapp/controllers/logger.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MessagingController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  RxString apnsToken = ''.obs;
  RxString fcmToken = ''.obs;
  final Logger _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    initializeFirebaseMessaging();

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    logPrint.i("Background message received: ${message.notification?.title}");
    // Add additional logic here if needed
  }

  Future<void> initializeFirebaseMessaging() async {
    // Request notification permissions
    final notificationSettings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {
      return;
    }

    // Fetch APNs token (iOS only)
    if (GetPlatform.isIOS) {
      final apnsTokenValue = await _firebaseMessaging.getAPNSToken();
      if (apnsTokenValue != null) {
        apnsToken.value = apnsTokenValue;
      }
    }

    // Fetch FCM token
    final fcmTokenValue = await _firebaseMessaging.getToken();
    if (fcmTokenValue != null) {
      fcmToken.value = fcmTokenValue;

      // Save token if user is authenticated
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await saveMessagingTokens(
          fcmTokenValue,
          apnsToken.value.isNotEmpty ? apnsToken.value : null,
        );
      }
    }

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      fcmToken.value = newToken;
      _logger.i('Refreshed FCM Token: $newToken');

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await saveMessagingTokens(
          newToken,
          apnsToken.value.isNotEmpty ? apnsToken.value : null,
        );
      }
    }).onError((err) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

    // Handle messages when the app is opened from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  Future<void> saveMessagingTokens(String fcmToken, [String? apnsToken]) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await db.collection('users').doc(uid).update({
        'fcmToken': fcmToken,
        if (apnsToken != null) 'apnsToken': apnsToken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Failed to save tokens: $e');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}
}
