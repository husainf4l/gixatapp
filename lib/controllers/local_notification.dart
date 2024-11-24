import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gixatapp/controllers/logger.dart';
import 'package:http/http.dart' as http;

// Initialize Flutter Local Notifications Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // Channel ID
    'High Importance Notifications', // Channel name
    description:
        'This channel is used for important notifications.', // Description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> setupForegroundNotification() async {
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsDarwin,
  );

  // Initialize Flutter Local Notifications
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Listen to Firebase Messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      String? imageUrl = message.data['image'];

      if (imageUrl != null) {
        // Show notification with an image
        _showNotificationWithImage(notification, imageUrl);
      } else {
        // Show regular notification
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            iOS: DarwinNotificationDetails(),
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    }

    // Save notification to Firestore
    await saveNotificationToFirestore(notification, message.data);
  });
}

Future<void> saveNotificationToFirestore(
    RemoteNotification? notification, Map<String, dynamic> data) async {
  try {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && notification != null) {
      await db.collection('notifications').add({
        'userUid': currentUser.uid,
        'userName': currentUser.displayName ?? 'Unknown User',
        'title': notification.title,
        'body': notification.body,
        'image': data['image'], // Save the image URL from the data payload
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
        "isChecked": false,
      });
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      'Failed to save notification to Firestore: $e',
      snackPosition: SnackPosition.TOP,
    );
  }
}

void _showNotificationWithImage(
    RemoteNotification notification, String imageUrl) async {
  try {
    // Download the image and save it locally
    final String? filePath = await _downloadImage(imageUrl);

    if (filePath != null) {
      // Define iOS-specific notification details
      final iOSDetails = DarwinNotificationDetails(
        attachments: [
          DarwinNotificationAttachment(filePath)
        ], // Attach the image
      );

      // Show the notification
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(iOS: iOSDetails),
      );
    }
  } catch (e) {
    logPrint.e("Error showing notification with image: $e");
  }
}

Future<String?> _downloadImage(String imageUrl) async {
  try {
    // Download the image using http package
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Save the file temporarily
      final directory = Directory.systemTemp;
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      logPrint.i("Failed to download image: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    logPrint.e("Error downloading image: $e");
    return null;
  }
}
