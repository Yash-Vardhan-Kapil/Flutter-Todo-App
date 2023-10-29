// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//final FirebaseAuth _auth = FirebaseAuth.instance;
var IncompleteList = "Incomplete Tasks";
var TodayList = "Today's List";
var FutureList = "Upcoming Tasks";
var ComList = "Completed Tasks";
var val;
var del_item =
    FirebaseFirestore.instance.collection("task").where('checker' == true);
final _storage = const FlutterSecureStorage();
Widget textfortask(text) {
  return Container(
    width: 150,
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 20,
      ),
      maxLines: 3,
    ),
  );
}

var firebase = FirebaseFirestore.instance.collection('task').snapshots();

Future<void> deleteToken() async {
  try {
    _storage.delete(key: "token");
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e);
  }
}
