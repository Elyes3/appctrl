import 'package:flutter/material.dart';

class ParentAppLimitorScreen extends StatelessWidget {
  const ParentAppLimitorScreen(
      {super.key, required this.uid, required this.fullName});
  final String fullName;
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fullName),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontFamily: 'MarkPro', fontSize: 25),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
