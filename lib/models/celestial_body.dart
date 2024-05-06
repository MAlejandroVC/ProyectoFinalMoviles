import 'dart:convert';
import 'package:http/http.dart' as http;

class CelestialBody {
  final String copyright;
  final String date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String serviceVersion;
  final String title;
  final String url;

  CelestialBody({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
  });

  factory CelestialBody.fromJson(Map<String, dynamic> json) {
    return CelestialBody(
      copyright: json['copyright'] ?? '',
      date: json['date'] ?? '',
      explanation: json['explanation'] ?? '',
      hdurl: json['hdurl'] ?? '',
      mediaType: json['media_type'] ?? '',
      serviceVersion: json['service_version'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

Future<List<CelestialBody>> fetchCelestialBodies(String apiKey) async {
  final response = await http.get('https://api.nasa.gov/planetary/apod?api_key=$apiKey&count=5');

  if (response.statusCode == 200) {
    List celestialBodiesJson = json.decode(response.body);
    return celestialBodiesJson.map((json) => CelestialBody.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load celestial bodies');
  }
}