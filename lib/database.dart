import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  static Future addNoteappDetails(
      Map<String, dynamic> noteappInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Noteapp")
        .doc(id)
        .set(noteappInfoMap);
  }

  static Future<Stream<QuerySnapshot>> getNoteappDetails() async {
    return await FirebaseFirestore.instance.collection("Noteapp").snapshots();
  }

  static Future updateNoteappDetails(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Noteapp")
        .doc(id)
        .update(updateInfo);
  }

  static Future deleteNoteappDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("Noteapp")
        .doc(id)
        .delete();
  }
}
