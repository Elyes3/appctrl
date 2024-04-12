import 'package:firebase_database/firebase_database.dart';
import 'package:parentalctrl/models/user.dart';
class ChildrenService {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  Future<List<Child>> fetchParentChildren(List<dynamic>? childrenIds) async {
    List<Child> children = [];
    print("CALLED CHILD");
    if (childrenIds != null) {
      for (var childId in childrenIds) {
        DatabaseEvent event = await ref.child('children/$childId').once();
        DataSnapshot dataSnapshot = event.snapshot;
        Map<String, dynamic> childMap =
            Map<String, dynamic>.from(dataSnapshot.value as Map);
        Child child = Child(childId, childMap['firstName'],
            childMap['lastName'], childMap['email'], childMap['parentId']);
        children.add(child);
      }
    }
    return children;
  }
}
