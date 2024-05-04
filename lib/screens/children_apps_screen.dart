import 'package:flutter/material.dart';
import 'package:parentalctrl/providers/children_provider.dart';
import 'package:parentalctrl/screens/parent_app_limiter.dart';
import 'package:parentalctrl/utils/date.dart';
import 'package:parentalctrl/widgets/chip.dart';
import 'package:provider/provider.dart';

class ChildrenAppsScreen extends StatefulWidget {
  const ChildrenAppsScreen({super.key, required this.selectedChild});
  final int selectedChild;

  @override
  State<ChildrenAppsScreen> createState() => _ChildrenAppsScreenState();
}

class _ChildrenAppsScreenState extends State<ChildrenAppsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChildrenProvider>(builder: (context, children, _) {
      return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text(
                '${children.children[widget.selectedChild].firstName} ${children.children[widget.selectedChild].lastName} Apps'),
            titleTextStyle: const TextStyle(
                color: Colors.white, fontFamily: 'MarkPro', fontSize: 25),
            backgroundColor: Colors.blue,
          ),
          body: children.children[widget.selectedChild].apps.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Image.asset(
                        'assets/no_apps.png',
                        width: 200,
                        height: 200,
                      ),
                      const Text(
                        'No apps found for this device !',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MarkPro'),
                      )
                    ]))
              : ListView.builder(
                  itemCount:
                      children.children[widget.selectedChild].apps.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(
                          children
                              .children[widget.selectedChild].apps[index].name,
                          style: const TextStyle(
                              fontFamily: 'MarkPro',
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Installed on : ${convertMillisToDate(children.children[widget.selectedChild].apps[index].installedOn)}'),
                              CustomChip(
                                  textColor: Colors.white,
                                  backgroundColor: children
                                              .children[widget.selectedChild]
                                              .apps[index]
                                              .enabled ==
                                          false
                                      ? const Color.fromARGB(255, 160, 160, 160)
                                      : Colors.blue,
                                  hasBorder: true,
                                  padding: 5.0,
                                  fontSize: 14.0,
                                  fontFamily: 'MarkPro',
                                  borderRadius: 15.0,
                                  text: children.children[widget.selectedChild]
                                          .apps[index].enabled
                                      ? 'ENABLED'
                                      : 'DISABLED')
                            ]),
                        trailing: IconButton(
                          icon: const Icon(Icons.east),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ParentAppLimiter(
                                        selectedChild: widget.selectedChild,
                                        selectedApp: index)));
                          },
                        ));
                  },
                ));
    });
  }
}
