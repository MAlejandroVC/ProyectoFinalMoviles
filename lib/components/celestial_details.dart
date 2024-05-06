import 'package:flutter/material.dart';
import '../models/celestial_body.dart';

class CelestialDetailsScreen extends StatelessWidget {
  final CelestialBody celestialBody;

  const CelestialDetailsScreen({
    Key? key,
    required this.celestialBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(celestialBody.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(
                celestialBody.hdurl,
                width: MediaQuery.of(context).size.width,
                height: null,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.0),
              Text(
                'Créditos: ${celestialBody.author}',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Fecha: ${celestialBody.date}',
                style: TextStyle(fontSize: 10.0),
              ),
              // Agregar más detalles aquí, como tamaño, composición, etc.
              Text(
                celestialBody.description,
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
