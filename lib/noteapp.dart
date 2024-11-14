import 'package:flutter/material.dart';
import 'package:noteapp_firebase/database.dart';
import 'package:random_string/random_string.dart';

class Noteapp extends StatefulWidget {
  const Noteapp({super.key});

  @override
  State<Noteapp> createState() => _EmployeeState();
}

class _EmployeeState extends State<Noteapp> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text("Employee",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Text("Form",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange)),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 25, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )),
              SizedBox(height: 8),
              Text(
                "Age",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: TextField(
                    controller: agecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )),
              SizedBox(height: 8),
              Text(
                "Location",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: TextField(
                    controller: locationcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )),
              SizedBox(height: 65),
              Center(
                  child: SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          String Id = randomAlphaNumeric(10);
                          Map<String, dynamic> employeeInfoMap = {
                            "Name": namecontroller.text,
                            "Age": agecontroller.text,
                            "Id": Id,
                            "location": locationcontroller.text,
                          };
                          await Database.addEmployeeDetails(
                              employeeInfoMap, Id);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    Text("Employee details added successfully"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("Add",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ))),
            ],
          ),
        ));
  }
}
