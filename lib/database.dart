import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';

class database {
  var popup_text_msg;
  var hp = homePage();
  final CollectionReference databaseCollection =
      FirebaseFirestore.instance.collection('task');

  Future storedata(String task, String date) async {}
}
