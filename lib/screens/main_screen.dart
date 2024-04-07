import 'package:flutter/material.dart';
import 'package:parentalctrl/screens/login.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Login()));
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
                  MaterialPageRoute(builder: (context) => const Login()));
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
