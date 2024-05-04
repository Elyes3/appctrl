import 'package:flutter/material.dart';
import 'package:parentalctrl/models/message.dart';
import 'package:parentalctrl/screens/login_screen.dart';
import 'package:parentalctrl/services/auth_service.dart';
import 'package:flutter/gestures.dart';

class ChildSignUpScreen extends StatefulWidget {
  const ChildSignUpScreen({super.key});

  @override
  State<ChildSignUpScreen> createState() => _ChildSignUpScreenState();
}

class _ChildSignUpScreenState extends State<ChildSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _data = {
    'firstName': '',
    'lastName': '',
    'parentEmail': '',
    'email': '',
    'password': ''
  };
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'Child Sign Up',
            style: TextStyle(color: Colors.white, fontFamily: 'MarkPro'),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: ListView(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'First Name',
                                  style: TextStyle(fontFamily: 'MarkPro'),
                                )
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _data["firstName"] = value ?? '';
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'John',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors.blue))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              }),
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Name',
                                  style: TextStyle(fontFamily: 'MarkPro'),
                                )
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _data["lastName"] = value ?? '';
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'Doe',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors.blue))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              }),
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Parent Email',
                                  style: TextStyle(fontFamily: 'MarkPro'),
                                )
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _data["parentEmail"] = value ?? '';
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'john.doe@xyz.com',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors.blue))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                String emailPattern =
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                RegExp regExp = RegExp(emailPattern);
                                if (!regExp.hasMatch(value)) {
                                  return 'Please write a valid email address';
                                }
                                return null;
                              }),
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(fontFamily: 'MarkPro'),
                                )
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _data["email"] = value ?? '';
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'john.doe@xyz.com',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors.blue))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                String emailPattern =
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                RegExp regExp = RegExp(emailPattern);
                                if (!regExp.hasMatch(value)) {
                                  return 'Please write a valid email address';
                                }
                                return null;
                              }),
                          const SizedBox(height: 10),
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Password",
                                  style: TextStyle(fontFamily: 'MarkPro'),
                                )
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _data["password"] = value ?? '';
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors.blue))),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              }),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          Message message =
                                              await _auth.registerChild(
                                                  _data["firstName"],
                                                  _data["lastName"],
                                                  _data["parentEmail"],
                                                  _data["email"],
                                                  _data["password"]);
                                          _data["password"] = '';
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(message.message),
                                          ));
                                          if (message.status == 201) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
                                          }
                                        }
                                      },
                                      style: const ButtonStyle(
                                        padding: MaterialStatePropertyAll<
                                                EdgeInsets>(
                                            EdgeInsets.fromLTRB(
                                                20, 20, 20, 20)),
                                        foregroundColor:
                                            MaterialStatePropertyAll<Color?>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color?>(
                                                Colors.blue),
                                      ),
                                      child: const Text('Sign Up',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'MarkProBold',
                                              letterSpacing: 2)))),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Divider(height: 3, color: Colors.grey),
                          const SizedBox(height: 15),
                          RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                      fontFamily: 'MarkPro',
                                      color: Colors.black,
                                      fontSize: 16),
                                  children: <TextSpan>[
                                const TextSpan(
                                    text: "Already have an account?  ",
                                    style: TextStyle(
                                        fontFamily: 'MarkPro',
                                        color: Colors.black)),
                                TextSpan(
                                  text: 'Login here',
                                  style: const TextStyle(
                                      fontFamily: 'MarkPro',
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen())),
                                )
                              ]))
                        ],
                      )))
            ])));
  }
}
