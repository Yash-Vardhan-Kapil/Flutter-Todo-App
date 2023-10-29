// ignore_for_file: non_constant_identifier_names, must_be_immutable, duplicate_ignore, camel_case_types, no_logic_in_create_state, unnecessary_this, avoid_print, prefer_const_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets.dart';

class List_Tile extends StatefulWidget {
  List_Tile(
      {required this.task_text,
      required this.cval,
      required this.id,
      required this.date,
      Key? key})
      : super(key: key);
  String task_text;
  bool cval;
  String id;
  String date;

  @override
  State<List_Tile> createState() => _List_TileState(task_text, cval, id, date);
}

class _List_TileState extends State<List_Tile> {
  bool? checkBoxValue;
  String task_text = "";
  String? taskid;
  String? displaytext;
  String? date;

  _List_TileState(this.task_text, bool cval, String id, this.date) {
    this.taskid = id;
    this.checkBoxValue = cval;
  }

  @override
  Widget build(BuildContext context) {
    if (task_text != "") {}
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        width: double.maxFinite,
        decoration: standard_decor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child:
                        Text(task_text, style: const TextStyle(fontSize: 35)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(date!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 15, 10),
              child: Row(
                children: [
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.check),
                        Text(
                          "Done",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      sendcheckervalue(true, taskid);
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.delete_outline),
                        Text(
                          "Delete",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      DocumentReference documentRefrence = FirebaseFirestore
                          .instance
                          .collection('task')
                          .doc(taskid);
                      documentRefrence.delete().whenComplete(() {
                        final snakbardelete = const SnackBar(
                            content: Text("Task Deleted!")); //snackbar msg

                        ScaffoldMessenger.of(context)
                            .showSnackBar(snakbardelete);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future sendcheckervalue(bool? check, String? taskId) async {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('task').doc(taskId);
  documentReference.update({'checker': check});
}

// ignore: must_be_immutable
class comp_page extends StatelessWidget {
  String? task;
  String? date;
  String? task_id;

  comp_page(
      {required this.task, required this.date, required this.task_id, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        width: double.maxFinite,
        decoration: standard_decor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Text(task!, style: const TextStyle(fontSize: 35)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(date!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 15, 10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.delete_outline),
                        Text(
                          "Delete",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      DocumentReference documentRefrence = FirebaseFirestore
                          .instance
                          .collection('task')
                          .doc(task_id);
                      documentRefrence.delete().whenComplete(() {
                        final snakbardelete = const SnackBar(
                            content: Text("Task Deleted!")); //snackbar msg

                        ScaffoldMessenger.of(context)
                            .showSnackBar(snakbardelete);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class incomp_page extends StatefulWidget {
  String? task;
  String? date;
  String? task_id;
  bool? checkBoxValue;
  incomp_page(
      {required this.task,
      required this.date,
      required this.task_id,
      required this.checkBoxValue,
      Key? key})
      : super(key: key);

  @override
  State<incomp_page> createState() =>
      _incomp_pageState(task, date, task_id, checkBoxValue);
}

class _incomp_pageState extends State<incomp_page> {
  String? task;
  String? date;
  String? task_id;
  bool? checkBoxValue;

  _incomp_pageState(this.task, this.date, this.task_id, this.checkBoxValue);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        width: double.maxFinite,
        decoration: standard_decor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Text(task!, style: const TextStyle(fontSize: 35)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(date!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 15, 10),
              child: Row(
                children: [
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.check),
                        Text(
                          "Done",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      sendcheckervalue(true, task_id);
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.delete_outline),
                        Text(
                          "Delete",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      DocumentReference documentRefrence = FirebaseFirestore
                          .instance
                          .collection('task')
                          .doc(task_id);
                      documentRefrence.delete().whenComplete(() {
                        final snakbardelete = const SnackBar(
                            content: Text("Task Deleted!")); //snackbar msg

                        ScaffoldMessenger.of(context)
                            .showSnackBar(snakbardelete);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
