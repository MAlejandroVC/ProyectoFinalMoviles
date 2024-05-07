import '../models/celestial_body.dart';
import 'package:flutter/material.dart';
import '../components/celestial_card.dart';

class CelestialGalleryScreen extends StatefulWidget {
  @override
  _CelestialGalleryScreenState createState() => _CelestialGalleryScreenState();
}

class _CelestialGalleryScreenState extends State<CelestialGalleryScreen> {
  late Future<List<CelestialBody>> futureCelestialBodies;
  int NUMBER_OF_IMAGES = 10;

  @override
  void initState() {
    super.initState();
    futureCelestialBodies = fetchGalleryCelestialBodies(NUMBER_OF_IMAGES);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galería Celestial'),
      ),
      body: FutureBuilder<List<CelestialBody>>(
        future: futureCelestialBodies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CelestialCard(
                  celestialBody: snapshot.data![index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
