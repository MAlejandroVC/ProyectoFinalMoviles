import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/celestial_body.dart';
import '../components/celestial_card.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: FirestoreListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        pageSize: 32,
        query: FirebaseFirestore.instance
            .collection('Favorites')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid),
        itemBuilder: (BuildContext context,
            QueryDocumentSnapshot<Map<String, dynamic>> jsonDocument) {
          final favoriteId = jsonDocument.id; // Get the document ID
          return CelestialCard(
              celestialBody: CelestialBody.fromApodJson(jsonDocument.data()));
        },
      ),
    );
  }
}
