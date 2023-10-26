import 'package:flutter/material.dart';

class TextInputState extends ChangeNotifier {
  late TextEditingController controller;

  TextInputState() {
    controller = TextEditingController();
  }

  void updateText(String newText) {
    controller.text = newText;
    notifyListeners();
  }

  // Dispose method to release resources
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
