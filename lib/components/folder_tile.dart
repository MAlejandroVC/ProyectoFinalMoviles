import 'package:flutter/material.dart';

import 'folder_details.dart';

class FolderTile extends StatelessWidget {
  final String folderName;

  FolderTile({required this.folderName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FolderDetails(folderName: folderName),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.folder,
            size: 100.0,
          ),
          Text(
            folderName,
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
