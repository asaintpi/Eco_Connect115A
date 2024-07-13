import 'package:flutter/foundation.dart';

class UserState with ChangeNotifier {
  String _phone = '';

  String get phone => _phone;

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }
}