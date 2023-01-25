import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF1A012E);
const kSecondaryColor = Color(0xFF130F40);
const kYellow = Color(0xFFFFAB0F);
const kViolet = Color(0xFF3B147A);

class Palette {
  static const Color iconColor = Color(0xFFB6C7D1);
  static const Color activeColor = Color(0xFF09126C);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color backgroundColor = Color(0xFFECF3F9);
}

const kPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
double kButtonHeight = 48;
FontWeight kFontWeight = FontWeight.w500;
double kElevation = 2;

Radius kRadius = const Radius.circular(10);
BorderRadius kBorderRadius = BorderRadius.circular(10);
Color kTextColor = Colors.grey.shade800;
Color kIconTextColor = Colors.grey.shade700;

final kElevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: kViolet,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));
