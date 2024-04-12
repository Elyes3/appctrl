import "package:flutter/material.dart";
import "package:parentalctrl/providers/user_provider.dart";
import "package:parentalctrl/screens/parent_home_screen.dart";
import "package:parentalctrl/screens/login_screen.dart";
import "package:parentalctrl/services/auth_service.dart";
import "package:provider/provider.dart";

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  final AuthService _auth = AuthService();
  @override
  void initState() {
    print("STATEFUL");
    super.initState();
    _auth.getAuthenticationStatus(context);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading == true) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Loading...'),
                titleTextStyle: const TextStyle(
                    color: Colors.white, fontFamily: 'MarkPro', fontSize: 25),
                backgroundColor: Colors.blue,
              ),
              body: const Center(child: CircularProgressIndicator()));
        } else if (userProvider.user == null) {
          // User is not logged in, navigate to login screen
          return const LoginScreen();
        } else {
          // User is logged in, navigate to home screen
          return const ParentHomeScreen();
        }
      },
    );
  }
}
