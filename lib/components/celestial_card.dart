import 'dart:async';
import 'package:provider/provider.dart';

import 'package:cosmic_explorer/services/favorites_service.dart';
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
      child: Consumer<FavoritesService>(
        builder: (context, FavoritesService, child) {
          return Column(
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
                    icon: FutureBuilder<bool>(
                      future: FavoritesService.isFavorite(celestialBody),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Icon(Icons.favorite_border);
                        } else {
                          if (snapshot.hasError) {
                            return Icon(Icons.error);
                          } else {
                            return Icon(snapshot.data == true
                                ? Icons.favorite
                                : Icons.favorite_border);
                          }
                        }
                      },
                    ),
                    onPressed: () async {
                      if (await FavoritesService.isFavorite(celestialBody)) {
                        // The celestial body is already a favorite so we remove it
                        FavoritesService.removeFavorite(celestialBody)
                            .then((success) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Removed from favorites'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Failed to remove from favorites'),
                              ),
                            );
                          }
                        });
                      } else {
                        // The celestial body is not a favorite so we add it
                        FavoritesService.addFavorite(celestialBody)
                            .then((success) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added to favorites'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add to favorites'),
                              ),
                            );
                          }
                        });
                      }
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
          );
        },
      ),
    );
  }
}
