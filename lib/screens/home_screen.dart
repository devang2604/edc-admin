import 'package:flutter/material.dart';
import 'package:vp_admin/models/user_data.dart';
import 'package:vp_admin/services/auth.dart';
import 'package:vp_admin/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _code;

  bool isLoading = false;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/scan');
              },
              child: const Text("Scan QR"),
            ),
          ),
          //Or enter the code manually
          //divider
          Row(
            children: const [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ),
              Text("OR"),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ),
            ],
          ),
          //enter code manually
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter the code',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _code = value;
                });
              },
              onEditingComplete: () async {
                if (_code == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter the code"),
                    ),
                  );
                  return;
                }
                setState(() {
                  isLoading = true;
                });
              },
              onSubmitted: (value) async {
                if (_code == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter the code"),
                    ),
                  );
                  return;
                }
              },
            ),
          ),
          //submit button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () async {
                if (_code == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter the code"),
                    ),
                  );
                  return;
                }
                print(await DatabaseService().verifyTicketId(_code!));
              },
              child: const Text("Submit"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //display the user data
          if (_code != null)
            FutureBuilder(
              future: DatabaseService().getTicketData(_code!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data as UserData?;
                  return Column(
                    children: [
                      Text("Email: ${userData!.email}"),
                      Text("Phone: ${userData.phone}"),
                    ],
                  );
                } else {
                  return const Text("No data");
                }
              },
            ),
        ],
      ),
    );
  }
}
