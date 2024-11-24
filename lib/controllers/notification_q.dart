import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gixatapp/controllers/auth_controller.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool hasUnreadNotifications = false.obs;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userData = Get.find<AuthController>().userData.value;

  @override
  void onInit() {
    super.onInit();
    listenForUnreadNotifications();
  }

  void listenForUnreadNotifications() {
    final String? uid = userData?['userUid'];
    if (uid != null) {
      _firestore
          .collection('notifications')
          .where('userId', isEqualTo: uid) // User-specific notifications
          .where('isChecked', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        // Update the observable value
        hasUnreadNotifications.value = snapshot.docs.isNotEmpty;
      });
    }
  }

  Future<void> markAllAsRead() async {
    final String? uid = Get.find<AuthController>().userData.value?['userUid'];

    if (uid != null) {
      final QuerySnapshot unreadNotifications = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: uid)
          .where('isChecked', isEqualTo: false)
          .get();

      for (final doc in unreadNotifications.docs) {
        await _firestore.collection('notifications').doc(doc.id).update({
          'isChecked': true,
        });
      }
      hasUnreadNotifications.value = false; // Update locally
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotificationsStream() {
    final String? uid = Get.find<AuthController>().userData.value?['userUid'];

    if (uid == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userUid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markAsRead(
      String notificationId, Map<String, dynamic> data) async {
    try {
      await _db.collection('notifications').doc(notificationId).update({
        ...data,
        'isChecked': true, // Mark the notification as read
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update notification: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
