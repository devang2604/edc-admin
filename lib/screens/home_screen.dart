import 'package:flutter/material.dart';
import 'package:vp_admin/models/ticket_data.dart';
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

  bool searchByEmail = false;

  String? email;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Search by: ",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              //Choice chip
              //Ticket Id, Email
              ChoiceChip(
                label: const Text("Ticket Id"),
                selected: !searchByEmail,
                onSelected: (value) {
                  setState(() {
                    searchByEmail = false;
                  });
                },
              ),
              const SizedBox(
                width: 20,
              ),
              ChoiceChip(
                label: const Text("Email"),
                selected: searchByEmail,
                onSelected: (value) {
                  setState(() {
                    searchByEmail = true;
                  });
                },
              ),
            ],
          ),
          //enter code manually
          searchByEmail
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter an email"),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter a code",
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
                  ),
                ),
          // //submit button
          if (searchByEmail)
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
                },
                child: const Text("Submit"),
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          //display the user data
          if (_code != null && _code!.length >= 4 && !searchByEmail)
            FutureBuilder(
              future: DatabaseService().getTicketData(_code!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final ticketData = snapshot.data as TicketData;
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          ticketData.name,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ticketData.email,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ticketData.phone,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ticketData.ticketType,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // UserData userData = UserData(
                            //   id: ticketData.ticketId,
                            //   email: ticketData.email,
                            //   phone: ticketData.phone,
                            //   firstName: ticketData.name,
                            // );
                            DatabaseService.addTicketToAdmittedUser(ticketData);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User added"),
                              ),
                            );
                          },
                          child: const Text("Admit User"),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text("No data");
                }
              },
            ),
          if (searchByEmail && email != null)
            FutureBuilder(
              future: DatabaseService().searchByEmail(email!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final ticketData = snapshot.data as TicketData;
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          ticketData.name,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ticketData.email,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ticketData.phone,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ticketData.ticketType,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // UserData userData = UserData(
                            //   id: ticketData.ticketId,
                            //   email: ticketData.email,
                            //   phone: ticketData.phone,
                            //   firstName: ticketData.name,
                            // );
                            DatabaseService.addTicketToAdmittedUser(ticketData);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User added"),
                              ),
                            );
                          },
                          child: const Text("Admit User"),
                        ),
                      ],
                    ),
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
