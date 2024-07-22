import 'package:flutter/foundation.dart';

class UserState with ChangeNotifier {
  String _phone = '';
  DateTime _signInTime = DateTime.now();

  String get phone => _phone;
  DateTime get signInTime => _signInTime;

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }
  void setSignInTime(DateTime signInTime) {
    _signInTime = signInTime;
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

