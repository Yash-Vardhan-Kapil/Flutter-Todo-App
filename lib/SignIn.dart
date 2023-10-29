import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/signup.dart';

import 'homepage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<SignIn> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // _auth is the object we created here
  final _storage =
      const FlutterSecureStorage(); // _storage is the object we created here
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> storeToken(UserCredential userCred) async {
    await _storage.write(
        key: "token", value: userCred.credential?.token.toString());
    await _storage.write(key: "data", value: userCred.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black87,
      resizeToAvoidBottomInset: true,
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 80, 0, 25),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            fontFamily: 'Comfortaa',
                            color: Colors.black,
                            //fontWeight: FontWeight.w500,
                            fontSize: 60),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.2,
                      ), //Border.all
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(
                            1.0,
                            3.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                          child: TextField(
                            onChanged: (value) {
                              //enaam = value;
                            },
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'User Name',
                              prefixIcon: Icon(Icons.person),
                              prefixIconColor: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                          child: TextField(
                            obscuringCharacter: "*",
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              prefixIconColor: Colors.grey,
                              labelText: 'Password',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _auth.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Container(
                            height: 60,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                print('SignIn Button Clicked!');
                                try {
                                  fba.UserCredential userCred =
                                      await _auth.signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text);
                                  print(userCred.user?.email);
                                  storeToken(userCred);
                                  print('Token stored');
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => homePage()),
                                      (route) => false);
                                } catch (e) {
                                  final snakbar =
                                      SnackBar(content: Text(e.toString()));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snakbar);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 2),
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              child: const Text('SignIn'),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Does not have account?'),
                            TextButton(
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                print('pushing to signup page');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => const SignUp()),
                                    (route) => false);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> getToken() async {
    await _storage.read(key: "token");
  }
}
