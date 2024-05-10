import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../models/celestial_body.dart';
import '../services/forum_service.dart';
import 'package:cosmic_explorer/components/comment_tile.dart';

class CelestialDetailsScreen extends StatefulWidget {
  final CelestialBody celestialBody;

  const CelestialDetailsScreen({
    Key? key,
    required this.celestialBody,
  }) : super(key: key);

  @override
  _CelestialDetailsScreenState createState() => _CelestialDetailsScreenState();
}

class _CelestialDetailsScreenState extends State<CelestialDetailsScreen> {
  bool _isDetailsExpanded = true;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.celestialBody.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await _downloadImageToGallery(widget.celestialBody.hdurl);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final file = await _downloadImage(widget.celestialBody.hdurl);
              final result = await Share.shareXFiles([XFile(file.path)],
                  text:
                      'Check out this celestial body: ${widget.celestialBody.title}');
              if (result.status == ShareResultStatus.success) {
                print('Thank you for sharing the picture!');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(
                widget.celestialBody.hdurl,
                width: MediaQuery.of(context).size.width,
                height: null,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  widget.celestialBody.author.isNotEmpty
                      ? Text(
                          'Credits: ${widget.celestialBody.author}',
                          style: TextStyle(fontSize: 12.0),
                        )
                      : Container(),
                  widget.celestialBody.date.isNotEmpty
                      ? Text(
                          'Date: ${widget.celestialBody.date}',
                          style: TextStyle(fontSize: 10.0),
                        )
                      : Container(),
                ],
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isDetailsExpanded = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text('Description',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)));
                    },
                    body: Text(
                      widget.celestialBody.description,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    isExpanded: _isDetailsExpanded,
                    canTapOnHeader: true,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text('Comments',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: ForumService().getComments(widget.celestialBody),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final comment = snapshot.data![index];
                        return CommentTile(
                          author: comment['author'],
                          textEntry: comment['textEntry'],
                          votesNumber: comment['votesNumber'],
                          isMine: comment['isMine'],
                          commentId: comment['id'],
                          celestialBody: widget.celestialBody,
                        );
                      },
                    );
                  }
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: 'Add a comment',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      ForumService()
                          .addComment(
                              _commentController.text, widget.celestialBody)
                          .then((success) => {
                                if (success)
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Comment added successfully.'),
                                    )),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Failed to add comment.'),
                                    )),
                                  }
                              });
                      _commentController.clear();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _downloadImageToGallery(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final name = '${widget.celestialBody.title}.jpg';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image downloaded to ${result['filePath']}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image')),
      );
    }
  }

  Future<File> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/image.jpg');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}
