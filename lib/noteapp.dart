import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:noteapp_firebase/database.dart';

class NotePage extends StatefulWidget {
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Box box;

  List<Map<String, String>> itemList = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  Stream<QuerySnapshot>? NoteappStream;

  getontheload() async {
    NoteappStream = await Database.getNoteappDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('mybox');

    final storedItems = box.get('itemList');
    if (storedItems is List) {
      itemList = List<Map<String, String>>.from(
          storedItems.map((e) => Map<String, String>.from(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note App Example"),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            final item = itemList[index];
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.pink),
                child: Column(
                  children: [
                    Text(item['title'] ?? 'No Title'),
                    Text(item['description'] ?? 'No Description'),
                    Text(item['category'] ?? 'No Category'),
                    Text(item['date'] ?? 'No Date'),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 500,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), hintText: 'title'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'description'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: categoryController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'category'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), hintText: 'date'),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    itemList.add({
                                      'title': titleController.text,
                                      'description': descriptionController.text,
                                      'caregory': categoryController.text,
                                      'date': dateController.text,
                                    });

                                    box.put(
                                        'itemList',
                                        itemList
                                            .map((e) =>
                                                Map<String, dynamic>.from(e))
                                            .toList());
                                  });

                                  titleController.clear();
                                  descriptionController.clear();
                                  categoryController.clear();
                                  dateController.clear();

                                  Navigator.pop(context);
                                },
                                child: Text("Add")),
                            SizedBox(width: 30),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
