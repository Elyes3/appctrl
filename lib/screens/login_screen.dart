import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parentalctrl/screens/main_screen.dart';
import 'package:parentalctrl/services/auth_service.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'App Control',
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
                                  'Email',
                                  style: TextStyle(fontFamily: 'MarkPro'),
                                )
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _email = value ?? '';
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
                          const SizedBox(height: 20),
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
                                  _password = value ?? '';
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
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          User? user = await _auth.login(
                                              _email, _password);
                                          if (!context.mounted) return;
                                          if (user != null) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainScreen()));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Failed to sign in:'),
                                            ));
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
                                      child: const Text('Login',
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
                                    text: "Don't have an account?  ",
                                    style: TextStyle(
                                        fontFamily: 'MarkPro',
                                        color: Colors.black)),
                                TextSpan(
                                  text: 'Sign up Here',
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
                                                const MainScreen())),
                                )
                              ]))
                        ],
                      )))
            ])));
  }
}
