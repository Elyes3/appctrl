import "package:flutter/material.dart";
import "package:parentalctrl/providers/user_provider.dart";
import "package:parentalctrl/screens/child_home_screen.dart";
import "package:parentalctrl/screens/parent_home_screen.dart";
import "package:parentalctrl/screens/login_screen.dart";
import "package:provider/provider.dart";

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.getAuthenticationStatus();
    });

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
        } else if (userProvider.user == null ||
            (userProvider.user != null && userProvider.user!.uid == null)) {
          // User is not logged in, navigate to login screen
          return const LoginScreen();
        } else if (userProvider.user != null &&
            userProvider.user!.uid != null &&
            userProvider.user!.isParent!) {
          return const ParentHomeScreen();
        } else {
          return const ChildHomeScreen();
        }
      },
    );
  }
}
