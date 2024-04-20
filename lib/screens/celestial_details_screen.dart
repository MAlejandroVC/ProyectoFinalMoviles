import 'package:flutter/material.dart';

class CelestialDetailsScreen extends StatelessWidget {
  final String planetName;
  final String imagePath;

  const CelestialDetailsScreen({
    Key? key,
    required this.planetName,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de $planetName'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20.0),
            Text(
              'Nombre: $planetName',
              style: TextStyle(fontSize: 20.0),
            ),
            // Agrega más detalles aquí, como tamaño, composición, etc.
            Text(
              'Mas detalles de $planetName de la API de NASA',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
