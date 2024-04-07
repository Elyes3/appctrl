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
  String parentEmail;
  Child(this.firstName, this.lastName, this.email, this.parentEmail);
}
