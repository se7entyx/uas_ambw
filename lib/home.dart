// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uas_ambw/addNotes.dart';
import 'package:uas_ambw/boxes.dart';
import 'package:uas_ambw/editNotes.dart';
import 'package:uas_ambw/note.dart';
import 'package:uas_ambw/changePassword.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: false,
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: notesBox.listenable(),
          builder: (context, Box<dynamic> box, _) {
            Box<Note> noteBox = box as Box<Note>;

            return ListView.builder(
              itemCount: noteBox.length,
              itemBuilder: (context, index) {
                Note note = noteBox.getAt(index) as Note;
                String formattedCreatedTime =
                    DateFormat('yyyy-MM-dd HH:mm').format(note.created);
                String formattedEditedTime =
                    DateFormat('yyyy-MM-dd HH:mm').format(note.edited);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    title: Text(
                      note.judul,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.isi,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Created: $formattedCreatedTime',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'Last Edited: $formattedEditedTime',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        noteBox.deleteAt(index);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditNotes(index: index)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotes()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
