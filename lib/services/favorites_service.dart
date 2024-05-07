import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:cosmic_explorer/models/celestial_body.dart';

class FavoritesService extends ChangeNotifier {
  Future<bool> addFavorite(CelestialBody celestialBody) async {
    try {
      notifyListeners();
      Map<String, dynamic> celestialBodyMap = celestialBody.toMap();
      celestialBodyMap['userId'] = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('Favorites')
          .add(celestialBodyMap);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavorite(CelestialBody) async {
    try {
      notifyListeners();
      await FirebaseFirestore.instance
          .collection('Favorites')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('title', isEqualTo: CelestialBody.title)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> isFavorite(CelestialBody celestialBody) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Favorites')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('title', isEqualTo: celestialBody.title)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
