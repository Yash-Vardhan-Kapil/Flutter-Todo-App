// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'homepage.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController RQController = TextEditingController();
  TextEditingController RQAController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController DOBController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 70),
              child: const Text(
                'Sign Up ',
                style: TextStyle(
                    fontFamily: 'Comfortaa', color: Colors.black, fontSize: 60),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: fnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'First Name',
                    )),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: lnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Last Name',
                    )),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Id',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    //onChanged: (){},
                    controller: _passwordController,
                    obscuringCharacter: "*",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Password',
                    )),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: mobController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile No.',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: RQController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Recovery Question',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: RQAController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Answer',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              keyboardType: TextInputType.none,
              controller: DOBController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date Of Birth',
              ),
              onTap: () async {
                DateTime? pickeddate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now());
                if (pickeddate != null) {
                  setState(() {
                    DOBController.text =
                        DateFormat('dd-MM-yyyy').format(pickeddate);
                  });
                }
              },
            ),
          ),
          Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
              child: ElevatedButton(
                onPressed: () async {
                  print("SignUp Button Clicked!");
                  try {
                    fb.UserCredential userCred =
                        await _auth.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                    print(userCred.user?.email);
                    //add remaining details to collection of user information
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => homePage()),
                        (route) => false);
                  } catch (e) {
                    final snakbar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snakbar);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 60, vertical: 6),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                child: const Text('Sign Up'),
              )),
        ],
      ),
    );
  }
}
