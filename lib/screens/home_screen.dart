import 'package:flutter/material.dart';
import 'package:vp_admin/models/ticket_data.dart';
import 'package:vp_admin/services/auth.dart';
import 'package:vp_admin/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  bool searchByEmail = false;

  String? email;
  String? code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Ticket'),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await AuthServices().signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      controller: _emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter an email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter the code"),
                      onChanged: (value) {
                        setState(() {
                          code = value;
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
                    setState(() {
                      //remove whitespaces
                      email = _emailController.text.trim();
                    });
                  },
                  child: const Text("Submit"),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            //display the user data
            if (code != null && code!.length >= 4 && !searchByEmail)
              FutureBuilder(
                future: DatabaseService().getTicketData(code!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final ticketData = snapshot.data as TicketData;
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                          FutureBuilder<bool>(
                            future: DatabaseService()
                                .isUserAdmitted(ticketData.ticketId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final isAdmitted = snapshot.data!;
                                if (isAdmitted) {
                                  return const Text(
                                    "User is admitted",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  );
                                } else {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200, 50),
                                    ),
                                    onPressed: () async {
                                      DatabaseService.addTicketToAdmittedUser(
                                          ticketData);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("User added"),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    child: const Text("Admit User"),
                                  );
                                }
                              } else {
                                return const LinearProgressIndicator();
                              }
                            },
                          )
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
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                          FutureBuilder<bool>(
                            future: DatabaseService()
                                .isUserAdmitted(ticketData.ticketId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final isAdmitted = snapshot.data!;
                                if (isAdmitted) {
                                  return const Text(
                                    "User is admitted",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  );
                                } else {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200, 50),
                                    ),
                                    onPressed: () async {
                                      DatabaseService.addTicketToAdmittedUser(
                                          ticketData);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("User added"),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    child: const Text("Admit User"),
                                  );
                                }
                              } else {
                                return const LinearProgressIndicator();
                              }
                            },
                          )
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
      ),
    );
  }
}
