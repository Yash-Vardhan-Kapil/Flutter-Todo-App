// ignore_for_file: camel_case_types, non_constant_identifier_names, use_full_hex_values_for_flutter_colors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/list_displays.dart';
import 'package:todo_app/homepage.dart';
import 'SignIn.dart';
import 'add-task-page.dart';
import 'complete_task.dart';
import 'database.dart';
import 'futurepage.dart';
import 'globals.dart';

class incomplete_task extends StatefulWidget {
  const incomplete_task({Key? key}) : super(key: key);

  @override
  State<incomplete_task> createState() => _incomplete_taskState();
}

class _incomplete_taskState extends State<incomplete_task> {
  TextEditingController task_inputController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int count = 0;

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  DateTime now = DateTime.now();
  String? task_id;

  @override
  void initState() {
    super.initState();
    // Initializing the date controller with the current date
    dateController.text = _formatDate(DateTime(now.year, now.month, now.day));
  }

  DateTime? newDateTime = DateTime.now();
  DateTime? date;
  var db = database();
  var hp = const homePage();
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
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
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("task")
                            .orderBy('date', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (BuildContext context, index) {
                                final DocumentSnapshot doc = snapshot.data
                                    ?.docs[index] as DocumentSnapshot<Object?>;
                                if (doc['checker'] == false) {
                                  return incomp_page(
                                    task: doc['task'],
                                    date: doc['date'],
                                    task_id: doc['id'],
                                    checkBoxValue: doc['checker'],
                                  );
                                } else {
                                  return const SizedBox(
                                    height: 0.0,
                                  );
                                }
                              });
                        },
                      )),
                    ],
                  )),
            ),
            Positioned(
              //gol button
              top: 140,
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
                        child: const Icon(Icons.home_filled),
                        label: 'Home',
                        backgroundColor: Colors.blue,
                        labelBackgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const homePage()));
                        }),
                    SpeedDialChild(
                        child: const Icon(Icons.check),
                        backgroundColor: Colors.green,
                        label: 'Complete task',
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
            ), //speed dial
            Positioned(
              //heading text
              top: 113,
              left: 94,
              child: Container(
                alignment: Alignment.centerLeft,
                //color: Colors.red,
                height: 100,
                width: 300,
                child: const Text("Incomplete Tasks",
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 40,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ), //heading
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
