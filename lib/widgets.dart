import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration standard_decor() {
  return BoxDecoration(
    border: Border.all(
      color: Colors.white,
      width: 0.2,
    ), //Border.all
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(
          0.0,
          0.0,
        ),
        blurRadius: 5.0,
        spreadRadius: 0.0,
      ), //BoxShadow
      BoxShadow(
        color: Colors.white,
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ), //BoxShadow
    ],
  );
}

Future<void> delete_listitem(String id) async {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('task').doc(id);
  documentReference.delete();
}
