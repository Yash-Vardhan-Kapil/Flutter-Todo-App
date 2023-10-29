import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'database.dart';

class add_task_page extends StatefulWidget {
  const add_task_page({Key? key}) : super(key: key);

  @override
  State<add_task_page> createState() => _add_task_pageState();
}

class _add_task_pageState extends State<add_task_page> {
  TextEditingController taskcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();

  var db = database();
  String? task_id;
  DateTime? newDateTime = DateTime.now();
  DateTime? date;
  DateTime now = DateTime.now();
  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  sucess() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Task Added Successfully!',
      showCancelBtn: true,
      cancelBtnText: 'Add Another',
      showConfirmBtn: true,
      confirmBtnText: 'done',
      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  void error() {
    QuickAlert.show(
        context: context, type: QuickAlertType.error, text: 'Task not added!');
  }

  @override
  void initState() {
    super.initState();
    // Initializing the date controller with the current date

    datecontroller.text = _formatDate(DateTime(now.year, now.month, now.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: taskcontroller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.task_alt),
                    labelText: "Task"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                // initialValue: _formatDate(DateTime.now()),
                controller: datecontroller,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  void _showDatePicker(BuildContext context) {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext builderContext) {
                        return Container(
                          height: 300,
                          color: CupertinoColors.white,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (newDateTime) {
                              setState(() {
                                date = newDateTime;
                                datecontroller.text = _formatDate(date!);
                              });
                            },
                          ),
                        );
                      },
                    );
                  }

                  _showDatePicker(context);
                  // print(dateController.text);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Add '),
                  onPressed: () {
                    print(taskcontroller);
                    print(datecontroller);
                    print('add button clicked!');

                    //db.storedata(task_inputController.text, dateController.text);

                    db.databaseCollection
                        .add({
                          'task': taskcontroller.text,
                          'date': datecontroller.text,
                          'checker': false,
                          'id': "",
                        })
                        .then((DocumentReference docref) {
                          // print('document id is ${docref.id}');
                          task_id = docref.id;
                        })
                        .whenComplete(() {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('task')
                                  .doc(task_id);
                          documentReference.update({'id': task_id});
                        })
                        .then((value) => sucess())
                        .catchError((value) => error());

                    taskcontroller.clear(); //clear textcontroller value
                    datecontroller.text =
                        _formatDate(DateTime.now()); //setting current date
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
