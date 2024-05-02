import "package:flutter/material.dart";
import "package:parentalctrl/models/user.dart";
import "package:parentalctrl/widgets/restriction_dialog.dart";
import 'package:percent_indicator/percent_indicator.dart';

class ParentAppLimiter extends StatelessWidget {
  const ParentAppLimiter({
    super.key,
    required this.child,
    required this.app,
  });
  final Child child;
  final App app;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                            app.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '${child.firstName} ${child.lastName}',
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
                    percent: 0.7,
                    center: const Text(
                      "70.0%",
                      style: TextStyle(
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Daily',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  fontFamily: 'MarkPro',
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '2h',
                                style: TextStyle(
                                    fontFamily: 'MarkPro', fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      )),
                      SizedBox(width: 4.0),
                      Expanded(
                          child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Weekly',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MarkPro',
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '1d 1h',
                                style: TextStyle(
                                    fontFamily: 'MarkPro', fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      )),
                      SizedBox(width: 4.0),
                      Expanded(
                          child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Monthly',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MarkPro',
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '5d',
                                style: TextStyle(
                                    fontSize: 14.0, fontFamily: 'MarkPro'),
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
                          const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Time Limit',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MarkPro',
                                      fontSize: 16.0),
                                ),
                                SizedBox(height: 8.0),
                                Text('Unset',
                                    style: TextStyle(
                                        fontFamily: 'MarkPro', fontSize: 18.0))
                              ]),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RestrictionDialog(
                                        child: child, app: app);
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
  }
}
