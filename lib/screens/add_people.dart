import 'package:flutter/material.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/models/user_data.dart';
import 'package:vp_admin/services/database.dart';
import 'package:vp_admin/utils/validators.dart';
import 'package:vp_admin/widgets/choice_button.dart';
import 'package:vp_admin/widgets/text_fields.dart';

class AddPeopleScrenn extends StatefulWidget {
  const AddPeopleScrenn({super.key});

  @override
  State<AddPeopleScrenn> createState() => _AddPeopleScrennState();
}

class _AddPeopleScrennState extends State<AddPeopleScrenn> {
  final _formKey = GlobalKey<FormState>();

  final UserData _userData = UserData(
    type: "Faculty",
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add People"),
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
                      label: "First Name",
                      hint: "Viraj",
                      onChanged: (value) {
                        setState(() {
                          _userData.firstName = value;
                        });
                      },
                    ),
                    InputTextField(
                      label: "Last Name",
                      hint: "Padale",
                      onChanged: (value) {
                        setState(() {
                          _userData.lastName = value;
                        });
                      },
                    ),
                    InputTextField(
                      label: "Email",
                      hint: "anas@gmail.com",
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _userData.email = value;
                        });
                      },
                    ),
                    InputTextField(
                      label: "Phone",
                      hint: "987654321",
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhoneNumber,
                      onChanged: (value) {
                        setState(() {
                          _userData.phone = value;
                        });
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    //Choice to select type of user
                    ChoiceButton(
                        value: _userData.type,
                        options: const ["Faculty", "Alumni"],
                        onChanged: (value) {
                          setState(() {
                            _userData.type = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: kElevatedButtonStyle,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await DatabaseService.addUser(_userData);
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("User admitted successfully!")));
                          }
                        },
                        child: const Text("Add"))
                  ],
                ),
              ));
  }
}
