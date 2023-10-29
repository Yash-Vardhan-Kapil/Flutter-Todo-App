// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print, use_full_hex_values_for_flutter_colors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/SignIn.dart';
import 'package:todo_app/add-task-page.dart';
import 'package:todo_app/list_displays.dart';
import 'package:todo_app/complete_task.dart';
import 'futurepage.dart';
import 'globals.dart' as gl;
import 'globals.dart';
import 'incomplete_task_page.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int count = 0;

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  final _storage = const FlutterSecureStorage();
  final isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          //close dial
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Container(
                //list item displaying container
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20), bottom: Radius.zero),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, -2.3), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                padding: const EdgeInsets.all(10),

                child: Container(
                  //color: Colors.red,
                  margin: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 65),
                  //color: Colors.red,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("task")
                        .snapshots(),
                    builder: (context, snapshot) {
                      DateTime now = DateTime.now();
                      DateTime date = DateTime(now.year, now.month, now.day);
                      String Sdate = _formatDate(date);
                      return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(5, 15, 0, 5),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            final doc = snapshot.data?.docs[index];
                            if (doc!['date'] == Sdate) {
                              return List_Tile(
                                  task_text: doc['task'],
                                  cval: doc['checker'],
                                  id: doc['id'],
                                  date: doc['date']);
                            } else {
                              return const SizedBox(
                                height: 0.0,
                              );
                            }
                          });
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              //gol button
              top: 120,
              left: 20,
              child: Transform.scale(
                scale: 1.3,
                child: SpeedDial(
                  direction: SpeedDialDirection.down,
                  switchLabelPosition: true,
                  animatedIcon: AnimatedIcons.menu_close,
                  backgroundColor: Colors.white,
                  animatedIconTheme:
                      const IconThemeData(color: Colors.blueGrey),
                  openCloseDial: isDialOpen,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.6,
                  spacing: 10,
                  spaceBetweenChildren: 7,
                  visible: true,
                  children: [
                    SpeedDialChild(
                        child: const Icon(Icons.check),
                        label: 'Completed tasks',
                        backgroundColor: Colors.green,
                        labelBackgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const complete_task()));
                        }),
                    SpeedDialChild(
                        child: const Icon(Icons.cancel_outlined),
                        backgroundColor: Colors.redAccent,
                        label: 'Incomplete task',
                        labelBackgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      const incomplete_task()));
                        }),
                    SpeedDialChild(
                        child: const Icon(Icons.watch_later_outlined),
                        label: 'Future tasks',
                        backgroundColor: Colors.cyanAccent,
                        labelBackgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const futurepage()));
                        }),
                    SpeedDialChild(
                      child: const Icon(Icons.logout),
                      label: 'Logout',
                      backgroundColor: const Color(0xff76f6fdff),
                      labelBackgroundColor: Colors.white,
                      labelStyle:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                      onTap: () {
                        deleteToken();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const SignIn()),
                            (route) => false);
                      },
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              //heading text
              top: 100,
              left: 92,
              child: Container(
                alignment: Alignment.centerLeft,
                //color: Colors.red,
                height: 100,
                width: 300,
                child: Text(gl.TodayList,
                    style: const TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 40,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const add_task_page()));
          },
          backgroundColor: Colors.blueGrey,
          label: const Text('Add Task'),
          icon: const Icon(Icons.add),
        ),
      ));
}
