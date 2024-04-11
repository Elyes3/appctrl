import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parentalctrl/models/user.dart';

class ChildrenProvider with ChangeNotifier {
  bool _isLoading = true;
  List<Child> _children = [];
  bool get isLoading => _isLoading;
  List<Child> get children => _children;
  void setChildren(List<Child> children) {
    _children = children;
    _isLoading = false;
    notifyListeners();
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  ChildrenProvider() {
    print("CALLED PHONE");
  }
}
