import 'dart:convert';

import 'package:http/http.dart' as http;

class TamagoRepository {
  final baseUrl = 'twisted-tamago.free.beeceptor.com';
  final client = http.Client();

  Future<TamagoPageResponse> getTamagoPage() async {
    final uri = Uri.https(baseUrl, '/tamagos');

    final response = await client.get(uri);
    final json = jsonDecode(response.body);

    return TamagoPageResponse.fromJson(json);
  }
}

class Tamago {
  final int id;
  final String name;

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  Tamago({required this.id, required this.name});

  factory Tamago.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final id = json['id'];
    return Tamago(id: id, name: name);
  }
}

class TamagoPageResponse {
  final List<Tamago> tamagoListing;

  TamagoPageResponse({required this.tamagoListing});

  factory TamagoPageResponse.fromJson(Map<String, dynamic> json) {
    final tamagoListings = (json['results'] as List)
        .map((tamagoJson) => Tamago.fromJson(tamagoJson))
        .toList();

    return TamagoPageResponse(tamagoListing: tamagoListings);
  }
}
