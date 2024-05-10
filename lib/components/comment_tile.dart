import 'package:cosmic_explorer/models/celestial_body.dart';
import 'package:flutter/material.dart';
import '../services/forum_service.dart';

class CommentTile extends StatefulWidget {
  final String author;
  final String textEntry;
  final int votesNumber;
  final bool isMine;
  final String commentId;
  final CelestialBody celestialBody;

  const CommentTile({
    Key? key,
    required this.author,
    required this.textEntry,
    required this.votesNumber,
    required this.isMine,
    required this.commentId,
    required this.celestialBody,
  }) : super(key: key);

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  final double _arrowIconSize = 15.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Votes
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: _arrowIconSize + 2.0,
            height: _arrowIconSize + 2.0,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_upward, size: _arrowIconSize),
              onPressed: () {
                ForumService()
                    .upvoteComment(widget.commentId, widget.celestialBody);
              },
            ),
          ),
          Text(widget.votesNumber.toString()),
          SizedBox(
            width: _arrowIconSize + 2.0,
            height: _arrowIconSize + 2.0,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_downward, size: _arrowIconSize),
              onPressed: () {
                ForumService()
                    .downvoteComment(widget.commentId, widget.celestialBody);
              },
            ),
          ),
        ],
      ),
      // Comment
      title: Text(
        '${widget.author}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      subtitle: Text(
        widget.textEntry,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      ),
      // Edit and Delete buttons
      trailing: widget.isMine
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.edit, size: 20.0),
                    onPressed: () {
                      final _editController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Edit Comment'),
                            content: TextField(
                              controller: _editController,
                              decoration: InputDecoration(
                                labelText: 'New comment',
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  final newTextEntry = _editController.text;
                                  ForumService()
                                      .editComment(widget.commentId,
                                          newTextEntry, widget.celestialBody)
                                      .then((success) => {
                                            if (success)
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Comment edited successfully.'),
                                                )),
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Failed to edit comment.'),
                                                )),
                                              }
                                          });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: 5.0), // Add some space between the buttons
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon:
                        Icon(Icons.delete, size: 20.0, color: Colors.redAccent),
                    onPressed: () {
                      ForumService()
                          .deleteComment(widget.commentId, widget.celestialBody)
                          .then((success) => {
                                if (success)
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Comment deleted successfully.'),
                                    )),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Failed to delete comment.'),
                                    )),
                                  }
                              });
                    },
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
