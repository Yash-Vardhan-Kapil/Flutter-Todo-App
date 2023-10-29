// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print, use_full_hex_values_for_flutter_colors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/SignIn.dart';
import 'package:todo_app/complete_task.dart';
import 'add-task-page.dart';
import 'globals.dart';
import 'list_displays.dart';
import 'database.dart';
import 'globals.dart' as gl;
import 'homepage.dart';
import 'incomplete_task_page.dart';

class futurepage extends StatefulWidget {
  const futurepage({Key? key}) : super(key: key);

  Future sendcheckervalue(String? check, String? task_id) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('task').doc(task_id);
    documentReference.update({'checker': check});
  }

  @override
  State<futurepage> createState() => _futurepageState();
}

class _futurepageState extends State<futurepage> {
  TextEditingController task_inputController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int count = 0;
  var hp = const homePage();
  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initializing the date controller with the current date
    dateController.text = _formatDate(DateTime(now.year, now.month, now.day));
  }

  DateTime? newDateTime = DateTime.now();
  DateTime? date;
  var db = database();

  final isDialOpen = ValueNotifier(false);
  String? task_id;
  Future<void> delete_listitem(String id) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('task').doc(id);
    documentReference.delete();
  }

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

                      return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(5, 15, 0, 5),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            final DocumentSnapshot doc = snapshot
                                .data?.docs[index] as DocumentSnapshot<Object?>;
                            DateTime tempDate =
                                DateFormat("dd-MM-yyyy").parse(doc['date']);
                            print("current date : $date");
                            print("doc date : $tempDate");
                            if (tempDate.compareTo(date) > 0) {
                              print('if condition true i.e, future task');
                              return List_Tile(
                                  task_text: doc['task'],
                                  cval: doc['checker'],
                                  id: doc['id'],
                                  date: doc['date']);
                            } else {
                              print('false');
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
                      child: const Icon(Icons.logout),
                      label: 'Logout',
                      backgroundColor: const Color(0xFF76F6FDFF),
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
            ), //gol btn
            Positioned(
              //heading text
              top: 100,
              left: 92,
              child: Container(
                alignment: Alignment.centerLeft,
                //color: Colors.red,
                height: 100,
                width: 300,
                child: Text(gl.FutureList,
                    style: const TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 40,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ), //heading text
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
