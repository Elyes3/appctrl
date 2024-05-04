import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:parentalctrl/models/message.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/services/permissions_service.dart';
import 'package:parentalctrl/services/application_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// firebase authentication instance
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  final service = FlutterBackgroundService();

  Future<UserData> fetchUserDataByRole(User? user) async {
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdTokenResult();
      Map<String, dynamic> customClaims =
          tokenResult.claims as Map<String, dynamic>;
      bool isParent = customClaims['isParent'] ?? false;
      if (!isParent) {
        getInstalledApps(user.uid, ref);
      }
      DataSnapshot snapshot = await ref
          .child(isParent ? 'parents' : 'children')
          .child(user.uid)
          .get();
      if (snapshot.exists) {
        List<dynamic> childrenIds = [];
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        if (userData["childrenIds"] != null) {
          childrenIds = userData["childrenIds"];
        }
        return UserData(
            user.uid,
            userData['email'],
            userData['firstName'],
            isParent ? childrenIds : null,
            userData['lastName'],
            isParent,
            'Logged In Successfully!');
      } else {
        return UserData.errorMessage('Error while fetching user data !');
      }
    } else {
      return UserData.errorMessage('This user does not exist !');
    }
  }

  Future<UserData> login(String email, String password) async {
    try {
      PermissionService permissionService = PermissionService();
      bool usageStatsPermissionGranted =
          await permissionService.checkUsageStatsPermissions();
      bool overlayPermissionGranted =
          await permissionService.checkOverlayPermissions();
      if (!usageStatsPermissionGranted) {
        usageStatsPermissionGranted =
            await permissionService.grantUsageStatsPermissions();
      }
      if (!overlayPermissionGranted) {
        overlayPermissionGranted =
            await permissionService.grantOverlayPermissions();
      }
      if (usageStatsPermissionGranted && usageStatsPermissionGranted) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        User? user = userCredential.user;
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('user_id', userCredential.user?.uid ?? '');
        UserData response = await fetchUserDataByRole(user);
        return response;
      } else {
        return UserData.errorMessage(
            'Please grant the permissions in order to continue');
      }
    } on FirebaseAuthException catch (error) {
      return UserData.errorMessage(error.message ?? '');
    }
  }


  Future<Message> registerParent(String? firstName, String? lastName,
      String? email, String? password) async {
    String endpoint = 'users/parent/signup';
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        firstName != null &&
        firstName.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty) {
      print(email);
      print(firstName);
      print(lastName);
      print(password);
      String body = json.encode({
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName
      });
      Message response = await fetchRegisterApi(body, endpoint);
      return response;
    } else {
      return Message('Please fill the missing fields !', null);
    }
  }

  Future<Message> registerChild(String? firstName, String? lastName,
      String? parentEmail, String? email, String? password) async {
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
      String body = json.encode({
        "email": email,
        "password": password,
        "parentEmail": parentEmail,
        "firstName": firstName,
        "lastName": lastName
      });
      Message response = await fetchRegisterApi(body, endpoint);
      return response;
    } else {
      return Message('Please fill the missing fields !', null);
    }
  }

  Future<Message> fetchRegisterApi(String body, String endpoint) async {
    try {
      var url =
          Uri.parse('https://kidsguard-be.onrender.com/api/$endpoint');
      print(url);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      dynamic jsonResponse = json.decode(response.body);
      return Message(jsonResponse['message'], response.statusCode);
    } catch (e) {
      return Message(e.toString(), null);
    }
  }

  Future<bool> signOut() async {
    try {
      bool isRunning = await service.isRunning();
      if (isRunning) {
        service.invoke("STOP_SERVICE");
      }
      await _auth.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }
}
