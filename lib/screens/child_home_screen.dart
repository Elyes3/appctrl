import 'package:flutter/material.dart';
import 'package:parentalctrl/providers/user_provider.dart';
import 'package:parentalctrl/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreen();
}

class _ChildHomeScreen extends State<ChildHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[10],
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                userProvider.signOut();
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
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset("assets/familyshield.jpeg"),
        const Text(
          "No data available",
          style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontFamily: "MarkPro"),
        ),
      ]),

      // body: Consumer<PhoneProvider>(
      //   builder: (context, model, _) {
      //     if (model.isLoading) {
      //       return const Center(
      //           child: CircularProgressIndicator(
      //         color: Colors.blue,
      //       ));
      //     } else if (model.phones.isEmpty) {
      //       return Center(
      //           child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Image.asset('assets/man_phone.png'),
      //           const SizedBox(height: 20),
      //           const Text(
      //             'No devices found !',
      //             style: TextStyle(
      //                 color: Colors.blue,
      //                 fontFamily: 'MarkProBold',
      //                 fontSize: 17,
      //                 letterSpacing: 2,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //           const SizedBox(height: 20),
      //           TextButton(
      //               onPressed: () {},
      //               style: const ButtonStyle(
      //                 padding: MaterialStatePropertyAll<EdgeInsets>(
      //                     EdgeInsets.fromLTRB(20, 15, 20, 15)),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color?>(Colors.white),
      //                 backgroundColor:
      //                     MaterialStatePropertyAll<Color?>(Colors.blue),
      //               ),
      //               child: const Text('Link with other devices',
      //                   style: TextStyle(
      //                       fontSize: 12,
      //                       fontFamily: 'MarkProBold',
      //                       letterSpacing: 2)))
      //         ],
      //       ));
      //     } else {
      //       return Container(
      //           margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      //           child: ListView.builder(
      //             itemCount: model.phones.length,
      //             itemBuilder: (BuildContext context, int index) {
      //               var device = model.phones[index];
      //               return Container(
      //                   margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(20),
      //                       color: Colors.red),
      //                   child: Material(
      //                       elevation: 15.0,
      //                       borderRadius: BorderRadius.circular(20),
      //                       child: Padding(
      //                           padding:
      //                               const EdgeInsets.fromLTRB(10, 0, 10, 0),
      //                           child: Theme(
      //                               data: Theme.of(context).copyWith(
      //                                   dividerColor: Colors.transparent),
      //                               child: ExpansionTile(
      //                                 title: Text(device.deviceName),
      //                                 subtitle: Row(children: [
      //                                   CustomChip(
      //                                       text: device.isWired
      //                                           ? 'WIRED'
      //                                           : 'NOT WIRED',
      //                                       textColor: Colors.white,
      //                                       backgroundColor: Colors.blue,
      //                                       hasBorder: true,
      //                                       padding: 4,
      //                                       fontSize: 10,
      //                                       fontFamily: 'MarkPro',
      //                                       borderRadius: 20),
      //                                   const SizedBox(width: 8),
      //                                   CustomChip(
      //                                       text: device.code,
      //                                       textColor: Colors.white,
      //                                       backgroundColor: Colors.blue,
      //                                       hasBorder: true,
      //                                       padding: 4,
      //                                       fontFamily: 'MarkPro',
      //                                       fontSize: 10,
      //                                       borderRadius: 20)
      //                                 ]),
      //                                 children: <Widget>[
      //                                   Row(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.spaceBetween,
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.center,
      //                                     children: [
      //                                       Row(children: [
      //                                         SvgPicture.asset(
      //                                           'assets/youtube.svg',
      //                                           width:
      //                                               24, // Adjust size as needed
      //                                           height:
      //                                               24, // Adjust size as needed
      //                                         ),
      //                                         const SizedBox(width: 5),
      //                                         const Text(
      //                                           "Youtube",
      //                                           style: TextStyle(
      //                                               fontFamily: "MarkPro",
      //                                               fontSize: 12),
      //                                         ),
      //                                       ]),
      //                                       Switch(
      //                                           inactiveThumbColor:
      //                                               Colors.white,
      //                                           inactiveTrackColor: Colors.blue,
      //                                           activeTrackColor: Colors.white,
      //                                           activeColor: Colors.blue,
      //                                           trackOutlineColor:
      //                                               MaterialStateProperty.all(
      //                                                   Colors.blue),
      //                                           value:
      //                                               device.isYoutubeRestricted,
      //                                           onChanged: (bool value) {
      //                                             Phone phone = Phone(
      //                                                 device.code,
      //                                                 device.isWired,
      //                                                 device.uuid,
      //                                                 device.deviceName,
      //                                                 value,
      //                                                 device
      //                                                     .isFacebookRestricted);
      //                                             model.updatePhone(phone);
      //                                           })
      //                                     ],
      //                                   ),
      //                                   Row(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.spaceBetween,
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.center,
      //                                     children: [
      //                                       Row(children: [
      //                                         SvgPicture.asset(
      //                                           'assets/facebook.svg',
      //                                           width:
      //                                               24, // Adjust size as needed
      //                                           height:
      //                                               24, // Adjust size as needed
      //                                         ),
      //                                         const SizedBox(width: 5),
      //                                         const Text(
      //                                           "Facebook",
      //                                           style: TextStyle(
      //                                               fontFamily: "MarkPro",
      //                                               fontSize: 12),
      //                                         ),
      //                                       ]),
      //                                       Switch(
      //                                           inactiveThumbColor:
      //                                               Colors.white,
      //                                           inactiveTrackColor: Colors.blue,
      //                                           activeTrackColor: Colors.white,
      //                                           activeColor: Colors.blue,
      //                                           trackOutlineColor:
      //                                               MaterialStateProperty.all(
      //                                                   Colors.blue),
      //                                           value:
      //                                               device.isFacebookRestricted,
      //                                           onChanged: (bool value) {
      //                                             Phone phone = Phone(
      //                                                 device.code,
      //                                                 device.isWired,
      //                                                 device.uuid,
      //                                                 device.deviceName,
      //                                                 device
      //                                                     .isYoutubeRestricted,
      //                                                 value);
      //                                             model.updatePhone(phone);
      //                                           })
      //                                     ],
      //                                   ),
      //                                 ],
      //                               )))));
      //             },
      //           ));
      //     }
      //   },
      // ),
    );
  }
}
