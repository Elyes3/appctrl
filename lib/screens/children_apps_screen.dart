import 'package:flutter/material.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/screens/parent_app_limiter.dart';
import 'package:parentalctrl/utils/date.dart';
import 'package:parentalctrl/widgets/chip.dart';

class ChildrenAppsScreen extends StatelessWidget {
  const ChildrenAppsScreen({super.key, required this.selectedChild});
  final Child selectedChild;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('${selectedChild.firstName} ${selectedChild.lastName} Apps'),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontFamily: 'MarkPro', fontSize: 25),
          backgroundColor: Colors.blue,
        ),
        body: selectedChild.apps.isEmpty
            ? const Center(child: Text('No apps found for this device !'))
            : ListView.builder(
                itemCount: selectedChild.apps.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(
                        selectedChild.apps[index].name,
                        style: const TextStyle(
                            fontFamily: 'MarkPro', fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Installed on : ${convertMillisToDate(selectedChild.apps[index].installedOn)}'),
                            CustomChip(
                                textColor: Colors.white,
                                backgroundColor: Colors.blue,
                                hasBorder: true,
                                padding: 5.0,
                                fontSize: 14.0,
                                fontFamily: 'MarkPro',
                                borderRadius: 15.0,
                                text: selectedChild.apps[index].enabled
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
                                      child: selectedChild,
                                      app: selectedChild.apps[index])));
                        },
                      ));
                },
              ));
  }
}
