import 'package:flutter/material.dart';
import 'package:parentalctrl/screens/parent_sign_up_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Control',
          style: TextStyle(color: Colors.white, fontFamily: 'MarkPro'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const ParentSignUpScreen()));
            },
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.fromLTRB(20, 15, 20, 15)),
              foregroundColor: MaterialStatePropertyAll<Color?>(Colors.white),
              backgroundColor: MaterialStatePropertyAll<Color?>(Colors.blue),
            ),
            child: const Text('Child',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'MarkProBold',
                    letterSpacing: 2))),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const ParentSignUpScreen()));
            },
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.fromLTRB(20, 15, 20, 15)),
              foregroundColor: MaterialStatePropertyAll<Color?>(Colors.white),
              backgroundColor: MaterialStatePropertyAll<Color?>(Colors.blue),
            ),
            child: const Text('Parent',
                style: TextStyle(
                    fontSize: 12, fontFamily: 'MarkProBold', letterSpacing: 2)))
      ])),
    );
  }
}
