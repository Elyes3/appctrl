import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Phone {
  String uuid;
  String code;
  bool isWired;
  String deviceName;
  bool isYoutubeRestricted;
  bool isFacebookRestricted;
  Phone(this.code, this.isWired, this.uuid, this.deviceName,
      this.isYoutubeRestricted, this.isFacebookRestricted);
}

class PhoneProvider with ChangeNotifier {
  bool _isLoading = true;
  List<Phone> _phones = [];
  bool get isLoading => _isLoading;
  List<Phone> get phones => _phones;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> getPhones() async {
    print("GOT HERE");
    final DataSnapshot snapshot = await ref.child('phones').get();
    Map<dynamic, dynamic> values = (snapshot.value as Map);
    if (snapshot.exists) {
      values.forEach((key, values) {
        Phone phone = Phone(
            values["code"],
            values["wired"],
            key,
            values["deviceName"],
            values["youtubeRestricted"],
            values["facebookRestricted"]);
        _phones.add(phone);
      });
    }
    _isLoading = false;
    print("I GOT HERE");
    notifyListeners();
  }

  Future<void> updatePhone(Phone phone) async {
    _phones =
        _phones.map((Phone p) => p.uuid == phone.uuid ? phone : p).toList();
    notifyListeners();
    await ref.child('phones').child(phone.uuid).update({
      'code': phone.code,
      'wired': true,
      'deviceName': phone.deviceName,
      'facebookRestricted': phone.isFacebookRestricted,
      'youtubeRestricted': phone.isYoutubeRestricted
    });
  }

  PhoneProvider() {
    print("CALLED PHONE");
    getPhones();
  }
}
