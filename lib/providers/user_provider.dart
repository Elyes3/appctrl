import 'package:flutter/material.dart';
import 'package:parentalctrl/models/user.dart';

class UserProvider with ChangeNotifier {
  bool _isLoading = true;
  UserData? _user = null;
  bool get isLoading => _isLoading;
  UserData? get user => _user;
  void setUser(UserData? user) {
    _user = user;
    _isLoading = false;
    print(_isLoading);
    print("Is notified");
    print(user);
    notifyListeners();
  }

  UserProvider();
}
