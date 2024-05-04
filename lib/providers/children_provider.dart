import 'package:flutter/material.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/services/children_service.dart';

class ChildrenProvider with ChangeNotifier {
  ChildrenProvider(
    this.service,
  );

  final ChildrenService service;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  List<Child> _children = [];
  List<Child> get children => _children;

  Future<void> fetchParentChildren(List<dynamic>? childrenIds) async {
    final List<Child> children = await service.fetchParentChildren(childrenIds);
    _children = children;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateRestrictions(Child selectedChild, bool untilReactivation,
      String time, App selectedApp) async {
    await service.updateRestrictions(
        selectedChild, untilReactivation, time, selectedApp);
  }
}
