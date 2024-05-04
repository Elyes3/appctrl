import 'package:flutter/material.dart';
import 'package:parentalctrl/providers/children_provider.dart';
import 'package:parentalctrl/providers/user_provider.dart';
import 'package:parentalctrl/screens/login_screen.dart';
import 'package:parentalctrl/screens/children_apps_screen.dart';
import 'package:parentalctrl/services/auth_service.dart';
import 'package:parentalctrl/services/children_service.dart';
import 'package:provider/provider.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreen();
}

class _ParentHomeScreen extends State<ParentHomeScreen> {
  AuthService authService = AuthService();
  ChildrenService childrenService = ChildrenService();
  @override
  void initState() {
    super.initState();
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final ChildrenProvider childrenProvider =
        Provider.of<ChildrenProvider>(context, listen: false);
    List<dynamic>? childrenIds = userProvider.user!.childrenIds;
    childrenProvider.fetchParentChildren(childrenIds);
    childrenService.listenForChildrenUpdates(
        userProvider.user!.uid!, childrenProvider);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        backgroundColor: Colors.grey[10],
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text('Children'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  userProvider.setUser(null);
                  authService.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                color: Colors.white,
                icon: const Icon(Icons.logout))
          ],
          titleTextStyle: const TextStyle(
              color: Colors.white, fontFamily: 'MarkPro', fontSize: 25),
          backgroundColor: Colors.blue,
        ),
        body: Consumer<ChildrenProvider>(builder: (context, model, _) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: model.children.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                      '${model.children[index].firstName} ${model.children[index].lastName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MarkPro',
                          fontSize: 17)),
                  subtitle: Text(
                    model.children[index].email,
                    style: const TextStyle(fontSize: 14, fontFamily: 'MarkPro'),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.east),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChildrenAppsScreen(
                                  selectedChild: index)));
                    },
                  ),
                );
              },
            );
          }
        }));
  }
}
