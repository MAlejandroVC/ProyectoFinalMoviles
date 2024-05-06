import '../models/celestial_body.dart';
import 'package:flutter/material.dart';
import '../components/celestial_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int NUMBER_OF_IMAGES = 10;
  String searchQuery = '';
  late Future<List<CelestialBody>> futureCelestialBodies;

  @override
  void initState() {
    super.initState();
    futureCelestialBodies = Future.value([]);
  }

  void _performSearch(String searchTerm) {
    setState(() {
      searchQuery = searchTerm;
      futureCelestialBodies =
          fetchSearchCelestialBodies(searchQuery, NUMBER_OF_IMAGES);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'Search...'),
          onSubmitted: _performSearch,
        ),
      ),
      body: FutureBuilder<List<CelestialBody>>(
        future: futureCelestialBodies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CelestialCard(
                  celestialBody: snapshot.data![index],
                  imageAspectRatio: 3 / 2,
                  fontSize: 12,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
