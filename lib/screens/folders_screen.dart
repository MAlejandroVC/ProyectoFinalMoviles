import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cosmic_explorer/components/folder_tile.dart';
import 'package:cosmic_explorer/services/folders_service.dart';

class FoldersScreen extends StatelessWidget {
  FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
      ),
      body: FirestoreListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        pageSize: 32,
        query: FirebaseFirestore.instance
            .collection('Folders')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid),
        itemBuilder: (BuildContext context,
            QueryDocumentSnapshot<Map<String, dynamic>> jsonDocument) {
          return FolderTile(folderName: jsonDocument['folderName']);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showNewFolderDialog(context);
        },
      ),
    );
  }

  void _showNewFolderDialog(BuildContext context) {
    final _folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: InputDecoration(hintText: "Enter folder name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (_folderNameController.text.isNotEmpty) {
                  await Provider.of<FoldersService>(context, listen: false)
                      .addFolder(_folderNameController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
