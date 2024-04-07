import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parentalctrl/models/childdto.dart';
import 'package:parentalctrl/models/parentdto.dart';
import 'package:parentalctrl/models/user.dart';

// firebase authentication instance
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return userCredential.user;
    } catch (error) {
      return null;
    }
  }

  Future<bool> checkParentEmailExists(String email) async {
    final DatabaseEvent parentsEvent =
        await ref.child("parents").orderByChild("email").equalTo(email).once();
    final DataSnapshot parentsSnapshot = parentsEvent.snapshot;
    print(parentsSnapshot.value);
    if (parentsSnapshot.value != null) {
      return true;
    }
    return false;
  }

  Future<bool> checkChildEmailExists(String email) async {
    final DatabaseEvent parentsEvent =
        await ref.child("children").orderByChild("email").equalTo(email).once();
    final DataSnapshot parentsSnapshot = parentsEvent.snapshot;
    print(parentsSnapshot.value);
    if (parentsSnapshot.value != null) {
      return true;
    }
    return false;
  }

  Future<ParentDTO> registerParent(String? firstName, String? lastName,
      String? email, String? password) async {
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        firstName != null &&
        firstName.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty) {
      try {
        bool checkParent = await checkParentEmailExists(email);
        if (checkParent) return ParentDTO('This email already exists !', null);
        _auth.createUserWithEmailAndPassword(email: email, password: password);
        ref.child('/parents').push().set({
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'email': email.trim(),
          'password': password.trim(),
        });
        return ParentDTO('Account created successfully !',
            Parent(firstName, lastName, email));
      } on FirebaseAuthException catch (error) {
        String? res = error.message ?? '';
        if (res.isNotEmpty) return ParentDTO(res, null);
        return ParentDTO('Some error happened !', null);
      }
    } else {
      return ParentDTO('Please fill the missing fields !', null);
    }
  }

  Future<ChildDTO> registerChild(String? firstName, String? lastName,
      String? parentEmail, String? email, String? password) async {
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        firstName != null &&
        firstName.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty &&
        parentEmail != null &&
        parentEmail.isNotEmpty) {
      try {
        bool checkParent = await checkParentEmailExists(email);
        if (!checkParent) {
          return ChildDTO("The parent email does not exist !", null);
        }
        bool checkChild = await checkChildEmailExists(email);
        if (checkChild) {
          return ChildDTO("The child email already exists !", null);
        }
        _auth.createUserWithEmailAndPassword(email: email, password: password);
        ref.child('/children').push().set({
          'firstName': firstName,
          'lastName': lastName,
          'parentEmail': parentEmail,
          'email': email,
          'password': password
        });
        return ChildDTO('Account created successfully !',
            Child(firstName, lastName, email, parentEmail));
      } on FirebaseAuthException catch (error) {
        String? res = error.message ?? '';
        if (res.isNotEmpty) return ChildDTO(res, null);
        ;
        return ChildDTO('Some error happened !', null);
      }
    } else {
      return ChildDTO('Please fill the missing fields !', null);
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }
}
