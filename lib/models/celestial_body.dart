import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class CelestialBody {
  final String author;
  final String date;
  final String description;
  final String hdurl;
  final String mediaType;
  final String title;
  final String url;
  final String center;

  CelestialBody({
    // Required parameters
    required this.description,
    required this.hdurl,
    required this.title,
    required this.url,

    // Optional parameters
    this.author = '',
    this.date = '',
    this.mediaType = '',
    this.center = '',
  });

  factory CelestialBody.fromApodJson(Map<String, dynamic> json) {
    return CelestialBody(
      author: json['copyright'] ?? '',
      date: json['date'] ?? '',
      description: json['explanation'] ?? '',
      hdurl: json['hdurl'] ?? '',
      mediaType: json['media_type'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      center: json['center'] ?? '',
    );
  }

  factory CelestialBody.fromNivlJson(Map<String, dynamic> json) {
    return CelestialBody(
      description: json['data'][0]['description'],
      hdurl: json['links'][0]['href'],
      title: json['data'][0]['title'],
      url: json['links'][0]['href'],
    );
  }

  Map toMap() {
    return {
      'author': author,
      'center': center,
      'date': date,
      'description': description,
      'hdurl': hdurl,
      'mediaType': mediaType,
      'title': title,
      'url': url,
    };
  }
}

Future<List<CelestialBody>> fetchGalleryCelestialBodies(
    int number_of_images) async {
  final apiKey = dotenv.dotenv.env['NASA_API_KEY'];
  final response = await http.get(Uri.parse(
      'https://api.nasa.gov/planetary/apod?api_key=$apiKey&count=$number_of_images'));

  if (response.statusCode == 200) {
    List celestialBodiesJson = json.decode(response.body);
    return celestialBodiesJson
        .map((json) => CelestialBody.fromApodJson(json))
        .toList();
  } else {
    throw Exception('Failed to load celestial bodies');
  }
}

Future<List<CelestialBody>> fetchSearchCelestialBodies(
    String searchTerm, int number_of_elements) async {
  final response = await http
      .get(Uri.parse('https://images-api.nasa.gov/search?q=$searchTerm'));

  if (response.statusCode == 200) {
    List celestialBodiesJson = json
        .decode(response.body)['collection']['items']
        .take(number_of_elements)
        .toList();
    return celestialBodiesJson
        .map((json) => CelestialBody.fromNivlJson(json))
        .toList();
  } else {
    throw Exception('Failed to load data from NASA API');
  }
}
