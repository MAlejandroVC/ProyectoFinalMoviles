import 'package:flutter/material.dart';
import 'celestial_details_screen.dart';

class CelestialGalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galería Celestial'),
      ),
      body: ListView(
        children: <Widget>[
          CelestialCard(
            planetName: 'Mercurio',
            imagePath: 'assets/images/mercury.jpg',
          ),
          CelestialCard(
            planetName: 'Venus',
            imagePath: 'assets/images/venus.jpg',
          ),
          CelestialCard(
            planetName: 'Tierra',
            imagePath: 'assets/images/earth.jpg',
          ),
        ],
      ),
    );
  }
}

class CelestialCard extends StatelessWidget {
  final String planetName;
  final String imagePath;

  const CelestialCard({
    Key? key,
    required this.planetName,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  planetName,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  // TODO: Implementar función para mostrar información
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CelestialDetailsScreen(
                        planetName: planetName,
                        imagePath: imagePath,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  // TODO: Implementar función para agregar a favoritos
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // TODO: Implementar función para agregar a una carpeta
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
