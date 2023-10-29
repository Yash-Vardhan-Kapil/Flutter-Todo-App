import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/SignIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget firstpage = const SignIn();
  final _storage = const FlutterSecureStorage();

  void checkToken() async {
    Future<String> Token = getToken();
    if (Token != null) {
      setState(() {
        firstpage = const homePage();
      });
    }
  }

  Future<String> getToken() async {
    return _storage.read(key: "token").toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: firstpage,
    );
  }
}
