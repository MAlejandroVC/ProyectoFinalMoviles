import '../models/celestial_body.dart';
import 'package:flutter/material.dart';
import 'celestial_details.dart';

class CelestialCard extends StatelessWidget {
  final CelestialBody celestialBody;
  final double imageAspectRatio;
  final double fontSize;

  const CelestialCard({
    Key? key,
    required this.celestialBody,
    this.imageAspectRatio = 16 / 9,
    this.fontSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: imageAspectRatio,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(celestialBody.url),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  celestialBody.title,
                  style: TextStyle(
                    fontSize: fontSize,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CelestialDetailsScreen(
                        celestialBody: celestialBody,
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
