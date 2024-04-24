import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_sample/functions.dart';
import 'package:login_sample/profile_screen.dart';
import 'package:login_sample/stdmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

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
        title: const Text('Search Students'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchStudents,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: 'Search Student name',
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(
                    Icons.search_sharp,
                    color: Colors.black,
                  )),
            ),
          ),
          Expanded(
            child: _buildStudentList(),
          ),
        ],
      ),
    );
  }

  void _searchStudents(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Widget _buildStudentList() {
    return ValueListenableBuilder<List<Students>>(
      builder: (context, studentList, child) {
        final filteredList = studentList.where((student) {
          return student.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();

        if (_searchQuery.isEmpty) {
          return Container();
        } else if (filteredList.isEmpty) {
          return const Center(
              child: Text(
            'No students here ',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ));
        } else {
          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final student = filteredList[index];
              return ListTile(
                leading: SizedBox.square(
                  dimension: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: student.image.isEmpty
                        ? Image.asset(
                            'assets/images/default-profile-picture1.jpg',
                          )
                        : Image.file(
                            File(student.image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                title: Text(student.name),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileStudentScreen(student: student),
                    ),
                  );
                },
              );
            },
          );
        }
      },
      valueListenable: studentListNotifier,
    );
  }
}
