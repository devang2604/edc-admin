import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/screens/add_people.dart';
import 'package:vp_admin/screens/admitted_people.dart';
import 'package:vp_admin/screens/home_screen.dart';
import 'package:vp_admin/screens/notifications.dart';
import 'package:vp_admin/screens/registration.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        _selectedIndex = pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [
          HomeScreen(),
          AddPeopleScrenn(),
          RegiterationScreen(),
          // NotificationScreen()
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() {
          _selectedIndex = i;
          //Smoothly animate to the page of the index
          pageController.animateToPage(i,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic);
        }),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.blueAccent,
          ),
          //Add People

          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.add_circled_solid),
            title: const Text("Add People"),
            selectedColor: Colors.blueAccent,
          ),

          ///Admitted Users
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.person),
            title: const Text("Registeration"),
            selectedColor: Colors.blueAccent,
          ),

          /// Notifications
          // SalomonBottomBarItem(
          //   icon: const Icon(CupertinoIcons.bell_fill),
          //   title: const Text("Notifications"),
          //   selectedColor: Colors.blueAccent,
          // ),
        ],
      ),
    );
  }
}
