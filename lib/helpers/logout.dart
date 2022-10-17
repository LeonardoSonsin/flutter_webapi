import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(BuildContext context) {
  SharedPreferences.getInstance().then((preferences) {
    preferences.clear();
    Navigator.pushReplacementNamed(context, "login");
  });
}
