import 'package:flutter/material.dart';
import 'package:vp_admin/packages/flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/screens/home_screen.dart';
import 'package:vp_admin/services/auth.dart';

class LoginScreen extends StatelessWidget {
  final AuthServices _auth = AuthServices();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        title: 'Vishwapreneur Admin'.toUpperCase(),
        hideForgotPasswordButton: true,
        // hideSignUpButton: true,
        //Decrease the size of the title
        theme: LoginTheme(
          authButtonPadding: const EdgeInsets.symmetric(vertical: 10),
          primaryColor: kViolet,
          cardTheme: const CardTheme(
            color: kPrimaryColor,
            // elevation: 0,
            // margin: const EdgeInsets.all(0),
          ),
          // accentColor: kSecondaryColor,
          // pageColorDark: kPrimaryColor,
          titleStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'BatmanForever',
            // color: kYellow,
            //Padding between the title and the logo
            // letterSpacing: 2,
            // color: Colors.white
          ),
          logoWidth: 0.35,
        ),
        logo: const AssetImage('assets/app_logo.png'),
        onLogin: _auth.signInWithEmailAndPassword,
        onSignup: (value) async {
          //SignUp is disabled
          return "SignUp is disabled from the admin panel";
        },
        onRecoverPassword: _auth.recoverPassword,
        // footer: "Designed and Developed by Anas Ansari",
        messages: LoginMessages(
          recoverPasswordDescription:
              'Enter your email to receive a link to reset your password',
        ));
  }
}
