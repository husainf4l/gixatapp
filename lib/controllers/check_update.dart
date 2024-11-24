import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gixatapp/controllers/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionController extends GetxController {
  RxString currentVersion = ''.obs;
  RxString latestVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initVersionCheck();
  }

  Future<void> _initVersionCheck() async {
    await _getCurrentVersion();
    await checkForUpdates();
  }

  Future<void> _getCurrentVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion.value = packageInfo.version;
  }

  Future<void> checkForUpdates() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version;

    // Replace this with your method to fetch the latest version dynamically
    const String latestVersion = "1.2.0";

    if (_isVersionNewer(latestVersion, currentVersion)) {
      // _showUpdateDialog();
      logPrint.i(currentVersion);
    }
  }

  bool _isVersionNewer(String latest, String current) {
    final latestParts = latest.split('.').map(int.parse).toList();
    final currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
        return true;
      } else if (latestParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }

  void _showUpdateDialog() {
    Get.defaultDialog(
      title: "تحديث متوفر",
      content: const Text("يرجى تحديث التطبيق للحصول على أحدث الميزات."),
      confirm: ElevatedButton(
        onPressed: () {
          _redirectToStore();
        },
        child: const Text("تحديث"),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("إلغاء"),
      ),
    );
  }

  void _redirectToStore() {
    const String appStoreLink =
        "https://apps.apple.com/jo/app/point-jordan/id6443648390";
    const String playStoreLink =
        "https://play.google.com/store/apps/details?id=com.papayatrading.point";

    final String storeUrl = Platform.isIOS ? appStoreLink : playStoreLink;
    launchUrl(Uri.parse(storeUrl));
  }
}

//  VersionController().checkForUpdates();
