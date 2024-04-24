import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_sample/edit_screen.dart';
import 'package:login_sample/functions.dart';
import 'package:login_sample/home.dart';
import 'package:login_sample/stdmodel.dart';

class ProfileStudentScreen extends StatefulWidget {
  final Students student;

  const ProfileStudentScreen({super.key, required this.student});

  @override
  State<ProfileStudentScreen> createState() => _ProfileStudentScreenState();
}

class _ProfileStudentScreenState extends State<ProfileStudentScreen> {
  bool isLoading = false;
  List<Students>? list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: const Text("Profile"),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white70,
                  title: const Text("Are You Sure You Want To Delete",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        await _deleteStudent(widget.student, context);
                        if (context.mounted)
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (ctx) => MyHome()));
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            color: Colors.black,
            onPressed: () async {
              if (isLoading) return;
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditStudentScreen(
                  student: widget.student,
                ),
              ));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox.square(
                dimension: 200,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.elliptical(50, 50),
                      right: Radius.elliptical(50, 50)),
                  child: widget.student.image.isEmpty
                      ? Image.asset(
                          defaultImageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.student.image),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  style: const TextStyle(
                      fontSize: 60, fontWeight: FontWeight.w500),
                  widget.student.name,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text("Age: ${widget.student.age} Years",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w300)),
                Text("Email: ${widget.student.email} ",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w300)),
                Text("Domain :  ${widget.student.domain}",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ],
      ),
      //
    );
  }

  Future<void> _deleteStudent(Students student, BuildContext ctx) async {
    try {
      deleteStudent(student.id!);
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          content: Text("Removed Sucesfully")));
    } catch (e) {
      log("Exception filed :${e.toString()}");
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text("Error Occured")));
    }
  }
}
