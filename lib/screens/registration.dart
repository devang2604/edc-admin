import 'package:flutter/material.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/models/ticket_data.dart';
import 'package:vp_admin/models/user_data.dart';
import 'package:vp_admin/services/database.dart';
import 'package:vp_admin/utils/validators.dart';
import 'package:vp_admin/widgets/choice_button.dart';
import 'package:vp_admin/widgets/text_fields.dart';

class RegiterationScreen extends StatefulWidget {
  const RegiterationScreen({super.key});

  @override
  State<RegiterationScreen> createState() => _RegiterationScreenState();
}

class _RegiterationScreenState extends State<RegiterationScreen> {
  final _formKey = GlobalKey<FormState>();

  TicketData ticketData = TicketData(
    ticketType: "Regular",
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("On Day Registration"),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  padding: kPadding,
                  children: [
                    InputTextField(
                      label: "Name",
                      onChanged: (value) {
                        setState(() {
                          ticketData.name = value;
                        });
                      },
                    ),
                    InputTextField(
                      label: "Email",
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          ticketData.email = value;
                        });
                      },
                    ),
                    InputTextField(
                      label: "Phone",
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhoneNumber,
                      onChanged: (value) {
                        setState(() {
                          ticketData.phone = value;
                        });
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    //Choice to select type of user
                    ChoiceButton(
                        value: ticketData.ticketType,
                        options: const ["Regular", "VIP"],
                        onChanged: (value) {
                          setState(() {
                            ticketData.ticketType = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: kElevatedButtonStyle,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            //Show confirmation dialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Registration"),
                                    content: Text(
                                        "Are you sure you want to register ${ticketData.name}"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            //Close dialog
                                            // Navigator.pop(context);
                                            // //Show loading indicator
                                            // setState(() {
                                            //   isLoading = true;
                                            // });
                                            //Add user to database
                                            var result =
                                                await DatabaseService.addTicket(
                                                    ticketData);
                                            if (result != null) {
                                              //Show success message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Registration Successful Ticket ID: $result")));
                                              //Clear form
                                              _formKey.currentState!.reset();
                                              //Hide loading indicator
                                              // setState(() {
                                              //   isLoading = false;
                                              // });
                                            } else {
                                              //Show error message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Registration Failed")));
                                              //Hide loading indicator
                                              // setState(() {
                                              //   isLoading = false;
                                              // });
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Confirm"))
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text("Add"))
                  ],
                ),
              ));
  }
}
