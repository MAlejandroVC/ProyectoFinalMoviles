import 'package:flutter/material.dart';

class FoldersScreen extends StatefulWidget {
  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  final List<String> folders = ['Folder 1', 'Folder 2', 'Folder 3']; // Replace this with your list of folders

  void _addFolder(String folderName) {
    setState(() {
      folders.add(folderName);
    });
  }

  void _renameFolder(int index, String newFolderName) {
    setState(() {
      folders[index] = newFolderName;
    });
  }

  void _deleteFolder(int index) {
    setState(() {
      folders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(folders[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implement your rename folder logic here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteFolder(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your add folder logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}