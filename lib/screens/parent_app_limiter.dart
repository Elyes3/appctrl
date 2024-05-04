import "package:flutter/material.dart";
import "package:parentalctrl/providers/children_provider.dart";
import "package:parentalctrl/providers/user_provider.dart";
import "package:parentalctrl/services/children_service.dart";
import "package:parentalctrl/utils/date.dart";
import "package:parentalctrl/widgets/restriction_dialog.dart";
import 'package:percent_indicator/percent_indicator.dart';
import "package:provider/provider.dart";

class ParentAppLimiter extends StatefulWidget {
  const ParentAppLimiter({
    super.key,
    required this.selectedChild,
    required this.selectedApp,
  });
  final int selectedChild;
  final int selectedApp;

  @override
  State<ParentAppLimiter> createState() => _ParentAppLimiterState();
}

double getTimePercentage(int time, int consumedTime, bool untilReactivation) {
  if (untilReactivation == true) {
    return 100;
  }
  if (untilReactivation == false && time == 0 && consumedTime == 0) {
    return 0;
  }
  if (time != 0) {
    if (consumedTime < time) {
      if (consumedTime != 0) {
        return (consumedTime / time) * 100;
      } else {
        return 0;
      }
    } else {
      return 100;
    }
  } else {
    return 0;
  }
}

class _ParentAppLimiterState extends State<ParentAppLimiter> {
  @override
  void initState() {
    super.initState();
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final ChildrenProvider childrenProvider =
        Provider.of<ChildrenProvider>(context, listen: false);
    ChildrenService childrenService = ChildrenService();
    childrenService.listenForChildAppUpdate(
        userProvider.user!.uid!,
        childrenProvider.children[widget.selectedChild].childId,
        childrenProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChildrenProvider>(builder: (context, children, _) {
      return Scaffold(
          appBar: AppBar(
                    iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: const Text('App Limiter'),
            titleTextStyle: const TextStyle(
                color: Colors.white, fontFamily: 'MarkPro', fontSize: 25),
            backgroundColor: Colors.blue,
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              children.children[widget.selectedChild]
                                  .apps[widget.selectedApp].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${children.children[widget.selectedChild].firstName} ${children.children[widget.selectedChild].lastName}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: getTimePercentage(
                              children.children[widget.selectedChild]
                                  .apps[widget.selectedApp].time,
                              children.children[widget.selectedChild]
                                  .apps[widget.selectedApp].consumedTime,
                              children.children[widget.selectedChild]
                                  .apps[widget.selectedApp].untilReactivation) /
                          100,
                      center: Text(
                        '${getTimePercentage(children.children[widget.selectedChild].apps[widget.selectedApp].time, children.children[widget.selectedChild].apps[widget.selectedApp].consumedTime, children.children[widget.selectedChild].apps[widget.selectedApp].untilReactivation)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      footer: const Text(
                        'Time Consumed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.0,
                                    fontFamily: 'MarkPro',
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  millisToTime(children
                                      .children[widget.selectedChild]
                                      .apps[widget.selectedApp]
                                      .time),
                                  style: const TextStyle(
                                      fontFamily: 'MarkPro', fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(width: 4.0),
                        Expanded(
                            child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Consumed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MarkPro',
                                    fontSize: 11.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  millisToTime(children
                                      .children[widget.selectedChild]
                                      .apps[widget.selectedApp]
                                      .consumedTime),
                                  style: const TextStyle(
                                      fontFamily: 'MarkPro', fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(width: 4.0),
                        Expanded(
                            child: Card(
                          color: children.children[widget.selectedChild]
                                      .apps[widget.selectedApp].isUsed ==
                                  true
                              ? Colors.blue
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Used Now',
                                  style: TextStyle(
                                    color: children
                                                .children[widget.selectedChild]
                                                .apps[widget.selectedApp]
                                                .isUsed ==
                                            true
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MarkPro',
                                    fontSize: 11.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  children
                                              .children[widget.selectedChild]
                                              .apps[widget.selectedApp]
                                              .isUsed ==
                                          true
                                      ? 'Yes'
                                      : 'No',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'MarkPro',
                                    color: children
                                                .children[widget.selectedChild]
                                                .apps[widget.selectedApp]
                                                .isUsed ==
                                            true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Time Limit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MarkPro',
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                      children
                                                  .children[
                                                      widget.selectedChild]
                                                  .apps[widget.selectedApp]
                                                  .time ==
                                              0
                                          ? "Unset"
                                          : "Set",
                                      style: const TextStyle(
                                          fontFamily: 'MarkPro',
                                          fontSize: 18.0))
                                ]),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RestrictionDialog(
                                          child: children
                                              .children[widget.selectedChild],
                                          app: children
                                              .children[widget.selectedChild]
                                              .apps[widget.selectedApp]);
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                                        EdgeInsets.fromLTRB(20, 10, 20, 10)),
                                    foregroundColor:
                                        const MaterialStatePropertyAll<Color?>(
                                            Colors.white),
                                    backgroundColor:
                                        const MaterialStatePropertyAll<Color?>(
                                            Colors.blue),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0)))),
                                child: const Text('RESTRICT',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'MarkProBold',
                                        letterSpacing: 2)))
                          ],
                        ),
                      ),
                    ),
                  ])));
    });
  }
}
