import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/providers/children_provider.dart';
import 'package:provider/provider.dart';

class ChildrenService {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  fetchParentChildren(String parentId, BuildContext context) async {
    ChildrenProvider childrenProvider =
        Provider.of<ChildrenProvider>(context, listen: false);
    DatabaseEvent event = await ref
        .child('children')
        .orderByChild('parentId')
        .equalTo(parentId)
        .once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<String, dynamic> childrenMap =
        Map<String, dynamic>.from(dataSnapshot.value as Map);
    List<Child> children = [];
    childrenMap.forEach((key, value) {
      Child child = Child(value['firstName'], value['lastName'], value['email'],
          value['parentId']);
      children.add(child);
      childrenProvider.setChildren(children);
    });
  }
}
