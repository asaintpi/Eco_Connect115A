import 'package:flutter/foundation.dart';

class UserState with ChangeNotifier {
  String _phone = '';

  String get phone => _phone;

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }
}

class LocationProvider extends ChangeNotifier {
  bool _locationOn = false;

  bool get locationOn => this._locationOn;

  void changeLocationPermission (bool perm,) async {
    _locationOn = perm;
    notifyListeners();

  }
}

