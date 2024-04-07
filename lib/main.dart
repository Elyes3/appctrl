import 'package:flutter/material.dart';
import 'package:parentalctrl/firebase_options.dart';
import 'package:parentalctrl/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:parentalctrl/models/phone.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhoneProvider(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 77, 91, 174)),
            useMaterial3: true,
          ),
          home: const Login()),
    );
  }
}
