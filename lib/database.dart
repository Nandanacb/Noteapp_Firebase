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
}
