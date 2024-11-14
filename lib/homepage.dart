import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:noteapp_firebase/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController categoryController=TextEditingController();
  TextEditingController dateController =TextEditingController();
  Stream<QuerySnapshot>? NoteappStream;

  getontheload() async {
    // Assuming Database.getEmployeeDetails() returns a Stream<QuerySnapshot>
    NoteappStream = await Database.getNoteappDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allNoteappDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: NoteappStream, // stream here cannot be null anymore
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No noteapp data available.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                       
                        children: [
                          Text(
                            "Title: " + (ds['Title'] ?? 'N/A'), // Null-aware operator
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              titleController.text=ds["Name"];
                              descriptionController.text=ds["Description"];
                              categoryController.text=ds["Category"];
                              dateController.text=ds["Date"];
                              EditNoteappDetails(ds["Id"]);

                            },
                            child:Icon(Icons.edit,color:Colors.orange)),
                            SizedBox(width:5),
                            GestureDetector(
                              onTap: ()async{
                               await Database.deleteNoteappDetails(ds["Id"]);

                              },
                              child: Icon(Icons.delete,color:Colors.red,)),
                        ],
                      ),
                      Text(
                        "Description: " + (ds['Description'] ?? 'N/A').toString(), // Ensure non-null
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Category: " + (ds['Category'] ?? 'N/A'), // Null-aware operator
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                     Text(
                        "Date: " + (ds['Date'] ?? 'N/A'), // Null-aware operator
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),









                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Flutter", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text("Firebase", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Expanded(child: allNoteappDetails()), // Displays the employee details stream
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Noteapp()));
        },
        child: Text("+"),
      ),
    );
  }

  Future EditNoteappDetails(String id)=>showDialog(context: context, builder: (context)=>AlertDialog(
content:Container(
  child: Column(
    children: [
      Row(
        children: [
          
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel)),
            SizedBox(width:60),
            Text("Edit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text("Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
          ],

      ),
      Text("Title",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height:8),
          SizedBox(
            height:50,
            width:300,
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(border:OutlineInputBorder(borderRadius: BorderRadius.circular(10))),)),
             SizedBox(height:8),
            Text("Description",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height:8),
          SizedBox(
            height:50,
            width:300,
            child: TextField(
              controller:descriptionController,
              decoration: InputDecoration(border:OutlineInputBorder(borderRadius: BorderRadius.circular(10))),)),

             SizedBox(height:8),
              Text("Category",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height:8),
          SizedBox(
            height:50,
            width:300,
            child: TextField(
              controller: categoryController,
              decoration: InputDecoration(border:OutlineInputBorder(borderRadius: BorderRadius.circular(10))),)),
              Text("Date",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height:8),
          SizedBox(
            height:50,
            width:300,
            child: TextField(
              controller: dateController,
              decoration: InputDecoration(border:OutlineInputBorder(borderRadius: BorderRadius.circular(10))),)),
             SizedBox(height:8),
  SizedBox(height:65),
  ElevatedButton(onPressed: () async {
    Map<String,dynamic> updateInfo={
      "Title":titleController.text,
      "Description":descriptionController.text,
      "Id":id,
      "Category":categoryController.text,

    };
    await Database.updateNoteappDetails(id, updateInfo).then((value){
      Navigator.pop(context);
    });
  }, child: Text("Update")),
    ],
  ),
),
  ));

}