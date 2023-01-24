import 'package:flutter/material.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/firebase_options.dart';
import 'package:vp_admin/screens/qr_scanner.dart';
import 'package:vp_admin/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vishwapreneur',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          // colorScheme: const ColorScheme.dark(
          //     primary: kPrimaryColor, secondary: kSecondaryColor),
        ),
        home: const Wrapper(),
        routes: {
          '/home': (context) => const Wrapper(),
          '/scan': (context) => const QRScanner(),
        }
        // navigatorKey: navigatorKey,
        );
  }
}
