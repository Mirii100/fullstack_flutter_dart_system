import 'package:flutter/material.dart';

class Constants {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.amber;
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // API Settings
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int pageSize = 20;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
}