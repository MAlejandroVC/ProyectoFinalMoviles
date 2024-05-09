import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import 'package:cosmic_explorer/models/celestial_body.dart';

class ForumService extends ChangeNotifier {
  // collection structure:
  // Forum (collection)
  //   - Document (document)
  //     - celestial_body (field)(string)
  //     - comments (field)(array[map])
  //       - comment_id (field)(string)
  //       - text_entry (field)(string)
  //       - user_id (field)(string)
  //       - user_name (field)(string)
  //       - votes (field)(int)

  final _commentsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get commentsStream =>
      _commentsController.stream;

  Future<bool> addComment(
      String text_entry, CelestialBody celestialBody) async {
    // 0. Generate a unique comment_id using the Uuid package.
    // 1. Check all the documents if the celestial_body field matches the celestialBody.title.
    // 2. If it does, add the comment to the comments array. Return true.
    // 3. If it doesn't, create a new document with the celestial_body field set to celestialBody.title and the comments array with the new comment. Return true.
    // 4. Return false.

    try {
      notifyListeners();
      final commentId = Uuid().v4();
      final snapshot = await FirebaseFirestore.instance
          .collection('Forum')
          .where('celestial_body', isEqualTo: celestialBody.title)
          .get();
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          doc.reference.update({
            'comments': FieldValue.arrayUnion([
              {
                'comment_id': commentId,
                'text_entry': text_entry,
                'user_id': FirebaseAuth.instance.currentUser!.uid,
                'user_name': FirebaseAuth.instance.currentUser!.displayName,
                'votes': 0,
              }
            ]),
          });
        });
        final comments = await getComments(celestialBody);
        _commentsController.add(comments);
        notifyListeners();
        return true;
      }
      await FirebaseFirestore.instance.collection('Forum').add({
        'celestial_body': celestialBody.title,
        'comments': [
          {
            'comment_id': commentId,
            'text_entry': text_entry,
            'user_id': FirebaseAuth.instance.currentUser!.uid,
            'user_name': FirebaseAuth.instance.currentUser!.displayName,
            'votes': 0,
          }
        ],
      });
      final comments = await getComments(celestialBody);
      _commentsController.add(comments);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getComments(
      CelestialBody celestialBody) async {
    // 1. Check all the documents if the celestial_body field matches the celestialBody.title.
    // 2. If it does, return the comments array.
    // 3. If it doesn't, return an empty list.
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Forum')
          .where('celestial_body', isEqualTo: celestialBody.title)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return [];
      }
      final comments = snapshot.docs.first.data()['comments'] as List;
      final commentsList = comments
          .map((comment) => {
                'author': comment['user_name'],
                'textEntry': comment['text_entry'],
                'votesNumber': comment['votes'],
                'isMine': comment['user_id'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                'id': comment['comment_id'],
              })
          .toList();
      notifyListeners();
      return commentsList;
    } catch (e) {
      print(e);
      notifyListeners();
      return [];
    }
  }

  Future<bool> isCommentMine(String commentId) async {
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Forum')
          .where('comments.comment_id', isEqualTo: commentId)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      notifyListeners();
      return snapshot.docs.first.data()['user_id'] ==
          FirebaseAuth.instance.currentUser!.uid;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteComment(
      String commentId, CelestialBody celestialBody) async {
    // 1. Check all the documents if the celestial_body field matches the celestialBody.title.
    // 2. If it does, look through the comments array for the comment with the comment_id field that matches the commentId.
    // 3. If it exists, update the comments array by removing the comment. Return true.
    // 4. If it doesn't exist, return false.
    // Before returning true, update the comments stream with the new comments array.
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Forum')
          .where('celestial_body', isEqualTo: celestialBody.title)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        final comments = doc.data()['comments'] as List;
        final newComments = comments
            .where((comment) => comment['comment_id'] != commentId)
            .toList();
        doc.reference.update({'comments': newComments});
      });
      final comments = await getComments(celestialBody);
      _commentsController.add(comments);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> editComment(
      String commentId, String newText, CelestialBody celestialBody) async {
    // 1. Check all the documents if the celestial_body field matches the celestialBody.title.
    // 2. If it does, look through the comments array for the comment with the comment_id field that matches the commentId.
    // 3. If it exists, update the text_entry field with the newText. Return true.
    // 4. If it doesn't exist, return false.
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Forum')
          .where('celestial_body', isEqualTo: celestialBody.title)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        final comments = doc.data()['comments'] as List;
        final newComments = comments.map((comment) {
          if (comment['comment_id'] == commentId) {
            return {
              'comment_id': comment['comment_id'],
              'text_entry': newText,
              'user_id': comment['user_id'],
              'user_name': comment['user_name'],
              'votes': comment['votes'],
            };
          }
          return comment;
        }).toList();
        doc.reference.update({'comments': newComments});
      });
      final comments = await getComments(celestialBody);
      _commentsController.add(comments);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> upvoteComment(
      String commentId, CelestialBody celestialBody) async {
    // 1. Check all the documents if the celestial_body field matches the celestialBody.title.
    // 2. If it does, look through the comments array for the comment with the comment_id field that matches the commentId.
    // 3. If it exists, update the votes field by incrementing it by 1. Return true.
    // 4. If it doesn't exist, return false.
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Forum')
          .where('celestial_body', isEqualTo: celestialBody.title)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        final comments = doc.data()['comments'] as List;
        final newComments = comments.map((comment) {
          if (comment['comment_id'] == commentId) {
            return {
              'comment_id': comment['comment_id'],
              'text_entry': comment['text_entry'],
              'user_id': comment['user_id'],
              'user_name': comment['user_name'],
              'votes': comment['votes'] + 1,
            };
          }
          return comment;
        }).toList();
        doc.reference.update({'comments': newComments});
      });
      final comments = await getComments(celestialBody);
      _commentsController.add(comments);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> downvoteComment(
      String commentId, CelestialBody celestialBody) async {
    // 1. Check all the documents if the celestial_body field matches the celestialBody.title.
    // 2. If it does, look through the comments array for the comment with the comment_id field that matches the commentId.
    // 3. If it exists, update the votes field by decrementing it by 1. Return true.
    // 4. If it doesn't exist, return false.
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Forum')
          .where('celestial_body', isEqualTo: celestialBody.title)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        final comments = doc.data()['comments'] as List;
        final newComments = comments.map((comment) {
          if (comment['comment_id'] == commentId) {
            return {
              'comment_id': comment['comment_id'],
              'text_entry': comment['text_entry'],
              'user_id': comment['user_id'],
              'user_name': comment['user_name'],
              'votes': comment['votes'] - 1,
            };
          }
          return comment;
        }).toList();
        doc.reference.update({'comments': newComments});
      });
      final comments = await getComments(celestialBody);
      _commentsController.add(comments);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }
}
