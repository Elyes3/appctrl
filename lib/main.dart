import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:parentalctrl/firebase_options.dart';
import 'package:parentalctrl/providers/children_provider.dart';
import 'package:parentalctrl/providers/user_provider.dart';
import 'package:parentalctrl/services/children_service.dart';
import 'package:parentalctrl/widgets/app_startup.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() async {
  debugPrint("Starting Alerting Window Isolate!");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        home: Scaffold(
          body:
              BlackBackgroundScreen(), // Your custom widget for white background screen
        ),
      )));
}

class BlackBackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Background color
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/error-bot.png'),
          const Text(
            'An error occured !',
            style: TextStyle(fontSize: 24.0, color: Colors.white),
          ),
          TextButton(
              child: Text("CLICK ME"),
              onPressed: () {
                FlutterOverlayWindow.closeOverlay();
              },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.fromLTRB(20, 15, 20, 15)),
                foregroundColor: MaterialStatePropertyAll<Color?>(Colors.white),
                backgroundColor: MaterialStatePropertyAll<Color?>(Colors.blue),
              )),
        ]),
      ),
    );
  }
}

ChildrenService _childrenService = ChildrenService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChildrenProvider>(
          create: (context) => ChildrenProvider(_childrenService),
        ),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider())
      ],
      child: MaterialApp(
          title: 'Parental Control',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 77, 91, 174)),
            useMaterial3: true,
          ),
          home: const AppStartup()),
    );
  }
}
