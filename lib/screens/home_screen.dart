import 'package:flutter/material.dart';
import 'package:vp_admin/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await AuthServices().signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              style: TextButton.styleFrom(
                primary: Colors.white,
              )),
        ],
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scan');
              },
              child: Text("Scan QR"))),
    );
  }
}
