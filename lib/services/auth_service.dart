import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parentalctrl/models/message.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// firebase authentication instance
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  Future<String> fetchUserDataByRole(
      User? user, UserProvider userProvider) async {
    print("GOT HERE");
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdTokenResult();
      Map<String, dynamic> customClaims =
          tokenResult.claims as Map<String, dynamic>;
      bool isParent = customClaims['isParent'] ?? false;
      DataSnapshot snapshot = await ref
          .child(isParent ? 'parents' : 'children')
          .child(user.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        userProvider.setUser(UserData(
            user.uid,
            userData['email'],
            userData['firstName'],
            userData['lastName'],
            isParent ? userData["childrenIds"] : null,
            isParent));
      } else {
        return 'Error while fetching user data !';
      }
    } else {
      userProvider.setUser(null);
      return 'This user does not exist !';
    }
    print("GOT HERE");
    return 'Logged In Successfully !';
  }

  Future<String> login(
      BuildContext context, String email, String password) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User? user = userCredential.user;

      String response = await fetchUserDataByRole(user, userProvider);
      return response;
    } on FirebaseAuthException catch (error) {
      return error.message ?? '';
    }
  }

  void getAuthenticationStatus(BuildContext context) {
    print("caLLed");
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    _auth.authStateChanges().listen((User? user) async {
      await fetchUserDataByRole(user, userProvider);
    });
  }

  Future<Message> registerParent(BuildContext context, String? firstName,
      String? lastName, String? email, String? password) async {
    String endpoint = 'users/parent/signup';
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        firstName != null &&
        firstName.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty) {
      String? baseUrl = dotenv.env['BASE_URL'];
      var url = Uri.parse('$baseUrl$endpoint');
      try {
        var response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "email": email,
              "password": password,
              "firstName": firstName,
              "lastName": lastName
            }));
        dynamic jsonResponse = json.decode(response.body);
        return Message(jsonResponse['message'], response.statusCode);
      } catch (e) {
        return Message(e.toString(), null);
      }
    } else {
      return Message('Please fill the missing fields !', null);
    }
  }

  Future<Message> registerChild(
      BuildContext context,
      String? firstName,
      String? lastName,
      String? parentEmail,
      String? email,
      String? password) async {
    String endpoint = 'users/child/signup';
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
        String? baseUrl = dotenv.env['BASE_URL'];
        var url = Uri.parse('$baseUrl$endpoint');
        var response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "email": email,
              "password": password,
              "parentEmail": parentEmail,
              "firstName": firstName,
              "lastName": lastName
            }));
        dynamic jsonResponse = json.decode(response.body);
        return Message(jsonResponse['message'], response.statusCode);
      } catch (e) {
        return Message(e.toString(), null);
      }
    } else {
      return Message('Please fill the missing fields !', null);
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
