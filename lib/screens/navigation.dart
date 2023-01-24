import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vp_admin/screens/add_people.dart';
import 'package:vp_admin/screens/admitted_people.dart';
import 'package:vp_admin/screens/home_screen.dart';
import 'package:vp_admin/screens/notifications.dart';

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
          AdmittedPeopleScreen(),
          NotificationScreen()
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
            selectedColor: Colors.teal,
          ),
          //Add People

          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.add_circled_solid),
            title: const Text("Add People"),
            selectedColor: Colors.teal,
          ),

          ///Admitted Users
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.group_solid),
            title: const Text("Admitted Users"),
            selectedColor: Colors.teal,
          ),

          /// Notifications
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.bell_fill),
            title: const Text("Notifications"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
