import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/folders_service.dart';
import '../models/celestial_body.dart';
import 'celestial_card.dart';

class FolderDetails extends StatefulWidget {
  final String folderName;

  FolderDetails({required this.folderName});

  @override
  _FolderDetailsState createState() => _FolderDetailsState();
}

class _FolderDetailsState extends State<FolderDetails> {
  late FoldersService _foldersService;

  @override
  void initState() {
    super.initState();
    _foldersService = Provider.of<FoldersService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final newFolderName = await getFolderName();
              if (newFolderName != null)
                await _foldersService.renameFolder(
                    widget.folderName, newFolderName);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _foldersService.removeFolder(widget.folderName);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CelestialBody>>(
        future: _foldersService.getFolderContent(widget.folderName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CelestialCard(
                  celestialBody: snapshot.data![index],
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<String?> getFolderName() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        final _folderNameController = TextEditingController();
        return AlertDialog(
          title: Text('Rename Folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: InputDecoration(hintText: "Enter new folder name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Rename'),
              onPressed: () {
                Navigator.of(context).pop(_folderNameController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
