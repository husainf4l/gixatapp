import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gixatapp/controllers/auth_controller.dart';
import 'package:gixatapp/controllers/bottom_nav_controller.dart';
import 'package:gixatapp/screens/inspection/inspection_page.dart';
import 'package:gixatapp/screens/mainPage/main_page.dart';
import 'package:flutter/cupertino.dart';

class Homepage extends StatelessWidget {
  final List<Widget> _pages = [
    const MainPage(),
    const MainPage(),
    InspectionPage(),
    const MainPage(),
    InspectionPage(),
  ];

  // Titles corresponding to each page
  final List<String> _titles = [
    'Transactions',
    'Home',
    'History',
    'About',
    'Inspection',
  ];

  Homepage({super.key});

  Future<void> refreshUserData() async {
    final authController = Get.find<AuthController>();
    await authController.refreshUserData();
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavController navController = Get.put(BottomNavController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Obx(
          () => AppBar(
            title: Text(_titles[navController.selectedIndex.value]),
            backgroundColor: Colors.cyan,
          ),
        ),
      ),
      body: Obx(() => _pages[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navController.selectedIndex.value,
            onTap: (index) {
              navController.changeIndex(index);
              refreshUserData();
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: '',
              ),
            ],
            selectedItemColor: Colors.cyan,
            unselectedItemColor: Colors.grey,
          )),
    );
  }
}
