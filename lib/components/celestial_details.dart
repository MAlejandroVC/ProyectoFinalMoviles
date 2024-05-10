import 'package:flutter/material.dart';

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
              // Forum style comments section goes here (ListView of CommentTile widgets)
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
}
