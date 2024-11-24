// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gixatapp/controllers/logger.dart';

class SettingsController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reactive settings data
  RxMap<String, dynamic> settingsData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  // Fetch settings from Firestore
  Future<void> fetchSettings() async {
    try {
      final docSnapshot = await _db.collection('settings').doc('global').get();
      if (docSnapshot.exists) {
        settingsData.value = docSnapshot.data()!;
      } else {
        logPrint.e("Settings document not found");
      }
    } catch (e) {
      logPrint.e("Error fetching settings: $e");
    }
  }

  // Optional: Method to fetch specific setting by key
  dynamic getSetting(String key) {
    return settingsData[key];
  }
}
