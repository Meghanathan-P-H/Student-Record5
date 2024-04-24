import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_sample/add_student.dart';
import 'package:login_sample/edit_screen.dart';
import 'package:login_sample/functions.dart';
import 'package:login_sample/login.dart';
import 'package:login_sample/profile_screen.dart';
import 'package:login_sample/search_screen.dart';
import 'package:login_sample/stdmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String defaultImageUrl = 'assets/images/default-profile-picture1.jpg';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MyHome> {
  bool isLoading = true;
  List<Students>? studentList;
  Students? student;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllStudent();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 10,
        automaticallyImplyLeading: false,
        title: const Text(
          '''STUDENT'S ZONE''',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
            onPressed: () {
              _signout(context);
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        builder: (BuildContext context, studentList, Widget? child) {
          if (studentList.isEmpty) {
            return const Center(
              child: Text(
                'No student available',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: getAllStudent,
            child: ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                final student = studentList[index];
                return SizedBox(
                  height: 80,
                  child: ListWidget(
                    student: student,
                  ),
                );
              },
            ),
          );
        },
        valueListenable: studentListNotifier,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () async {
          showModalBottomSheet(
            enableDrag: true,
            context: context,
            builder: (context) => SizedBox(
                child: AddStudentScreen(
              student: student,
            )),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }

  void _signout(BuildContext ctx) async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();

    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.lightBlue,
          elevation: 8.0,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    required this.student,
  });

  final Students student;
  final String defaultImageUrl = 'assets/images/default-profile-picture1.jpg';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20.0)),
        color: const Color.fromARGB(255, 255, 255, 255),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileStudentScreen(
                student: student,
              ),
            ));
          },
          leading: SizedBox.square(
            dimension: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: student.image.isEmpty
                  ? Image.asset(defaultImageUrl)
                  : Image.file(
                      File(student.image),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Text(
            student.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            student.domain,
            style: const TextStyle(color: Colors.brown),
          ),
          trailing: Wrap(
            spacing: 20,
            direction: Axis.horizontal,
            children: [
              IconButton(
                color: Colors.blue,
                onPressed: () {
                  showModalBottomSheet(
                    enableDrag: true,
                    context: context,
                    builder: (context) => EditStudentScreen(
                      student: student,
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Are You Sure You Want To Delete ?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel",
                              style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton.icon(
                            onPressed: () async {
                              await deleteStudent(student.id!);
                              if (context.mounted) Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.delete_sweep_sharp,
                            ),
                            label: const Text("Delete",
                                style: TextStyle(color: Colors.black)))
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteStudent(Students student, BuildContext ctx) async {
    try {
      await deleteStudent(student.id!);
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
          backgroundColor: Color.fromARGB(255, 255, 17, 0),
          content: Text("Error Occured")));
    }
  }
}
