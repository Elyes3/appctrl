import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

  Future<String> registerParent(String? firstName, String? lastName,
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
        if (checkParent) return "This email already exists !";
        _auth.createUserWithEmailAndPassword(email: email, password: password);
        ref.child('/parents').push().set({
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'email': email.trim(),
          'password': password.trim(),
        });
        return 'Account created successfully !';
      } on FirebaseAuthException catch (error) {
        String? res = error.message ?? '';
        if (res.isNotEmpty) return res;
        return 'Some error happened !';
      }
    } else {
      return 'Please fill the missing fields !';
    }
  }

  Future<String> registerChild(String? firstName, String? lastName,
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
        if (!checkParent) return "The parent email does not exist !";
        bool checkChild = await checkChildEmailExists(email);
        if (checkChild) return "The child email already exists !";
        _auth.createUserWithEmailAndPassword(email: email, password: password);
        ref.child('/children').push().set({
          'firstName': firstName,
          'lastName': lastName,
          'parentEmail': parentEmail,
          'email': email,
          'password': password
        });
        return 'Account created successfully !';
      } on FirebaseAuthException catch (error) {
        String? res = error.message ?? '';
        if (res.isNotEmpty) return res;
        return 'Some error happened !';
      }
    } else
      return 'Please fill the missing fields !';
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
