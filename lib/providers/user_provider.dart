import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parentalctrl/background_service/background_service.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  UserData? _user;
  bool get isLoading => _isLoading;
  UserData? get user => _user;
  AuthService authService = AuthService();
  void setUser(UserData? user) {
    _user = user;
    _isLoading = false;
    print(_isLoading);
    print("Is notified");
    print(user?.uid);
    notifyListeners();
  }

  void signOut() {
    setUser(null);
    authService.signOut();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    UserData userData = await authService.login(email, password);
    print(userData.email);
    print(userData.message);
    setUser(userData);
    notifyListeners();
    if (userData.uid != null) {
      if (userData.isParent == false) {
        await restrictApps();
      }
    }
  }

  void getAuthenticationStatus() async {
    _auth.authStateChanges().listen((User? user) async {
      print(user);
      UserData? userData = await authService.fetchUserDataByRole(user);
      setUser(userData);
      notifyListeners();
    });
  }

  UserProvider();
}
