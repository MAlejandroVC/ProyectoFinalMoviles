import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:cosmic_explorer/models/celestial_body.dart';

class FoldersService extends ChangeNotifier {
  Future<bool> addFolder(String folderName) async {
    // 1. Check if a folder with the same name already exists
    // 2. If it does, return false
    // 3. If it doesn't, add the folder to the user's folders collection
    // 4. Return true
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('folderName', isEqualTo: folderName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        notifyListeners();
        return false;
      }
      await FirebaseFirestore.instance.collection('Folders').add({
        'folderName': folderName,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'celestialBodies': [],
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFolder(String folderName) async {
    // 1. Check if a folder with that name exists
    // 2. If it doesn't, return false
    // 3. If it does, remove the folder from the user's folders collection
    // 4. Return true
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('folderName', isEqualTo: folderName)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> renameFolder(String folderName, String newFolderName) async {
    // 1. Check if a folder with that name exists
    // 2. If it doesn't, return false
    // 3. Check if a folder with the NEW name already exists
    // 4. If it does, return false
    // 5. Rename the folder in the user's folders collection
    // 6. Return true
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('folderName', isEqualTo: folderName)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      final newSnapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('folderName', isEqualTo: newFolderName)
          .get();
      if (newSnapshot.docs.isNotEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        doc.reference.update({'folderName': newFolderName});
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> addCelestialBodyToFolder(String folderName, CelestialBody celestialBody) async {
    // 1. Check if a folder with that name exists
    // 2. If it doesn't, return false
    // 3. Check if the celestial body is already in the folder
    // 4. If it is, return false
    // 5. Get array of celestial bodies in the folder
    // 6. Add the celestial body to the array
    // 7. Update the folder with the new array
    // 8. Return true
    bool celestial_body_in_folder = false;

    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('folderName', isEqualTo: folderName)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final celestialBodies = data['celestialBodies'] as List;
        final celestialBodyMap = celestialBody.toMap();

        if (celestialBodies
            .any((body) => body['title'] == celestialBody.title)) {
          celestial_body_in_folder = true;
          return;
        }

        celestialBodies.add(celestialBodyMap);
        doc.reference.update({'celestialBodies': celestialBodies});
      });
      notifyListeners();
      if (celestial_body_in_folder) return false;
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeCelestialBodyFromFolder(
      String folderName, CelestialBody celestialBody) async {
    // 1. Check if a folder with that name exists
    // 2. If it doesn't, return false
    // 3. Check if the celestial body is in the folder
    // 4. If it isn't, return false
    // 5. Remove the celestial body from the folder
    // 6. Return true
    bool celestial_body_in_folder = false;
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('folderName', isEqualTo: folderName)
          .get();
      if (snapshot.docs.isEmpty) {
        notifyListeners();
        return false;
      }
      snapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final celestialBodies = data['celestialBodies'] as List;
        if (!celestialBodies.contains(celestialBody.title)) {
          celestial_body_in_folder = true;
          return;
        }
        celestialBodies.remove(celestialBody.title);
        doc.reference.update({'celestialBodies': celestialBodies});
      });
      notifyListeners();
      if (celestial_body_in_folder) return false;
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<List<CelestialBody>> getFolderContent(String folderName) async {
    // 1. Check if a folder with that name exists
    // 2. If it doesn't, return an empty list
    // 3. Return the celestial bodies in the folder
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('folderName', isEqualTo: folderName)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final celestialBodiesData = data['celestialBodies'] as List;
      return celestialBodiesData.map((data) {
        return CelestialBody(
          author: data['author'] ?? '',
          center: data['center'] ?? '',
          date: data['date'] ?? '',
          description: data['description'] ?? '',
          hdurl: data['hdurl'] ?? '',
          mediaType: data['mediaType'] ?? '',
          title: data['title'] ?? '',
          url: data['url'] ?? '',
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> getFolderNames() async {
    // 1. Get the list of folders
    // 2. Return the folder names
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      return snapshot.docs.map((doc) {
        return doc['folderName'] as String;
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
