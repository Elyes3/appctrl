class Parent {
  String firstName;
  String lastName;
  String email;
  Parent(this.firstName, this.lastName, this.email);
}

class Child {
  String firstName;
  String lastName;
  String email;
  String parentId;
  Child(this.firstName, this.lastName, this.email, this.parentId);
}

class UserData {
  String email;
  String uid;
  String firstName;
  String lastName;
  bool isParent;
  List<String>? childrenIds;
  UserData(this.uid, this.email, this.firstName, this.childrenIds,
      this.lastName, this.isParent);
}
