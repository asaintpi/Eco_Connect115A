import 'package:flutter/foundation.dart';

// All variables needed by the program locally are defined by UserState for a specific user instance
class UserState with ChangeNotifier {
  String _phone = '';
  String _email = '';
  DateTime _signInTime = DateTime.now();

  String get phone => _phone;
  String get email => _email;
  DateTime get signInTime => _signInTime;

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }
  void setEmail(String email) {
    _email = email;
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

