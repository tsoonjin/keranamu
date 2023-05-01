import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List> cardCollection;

  @override
  void initState() {
    super.initState();
    cardCollection = fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white60,
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.7,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2)),
                    child: Column(children: const <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Search... e.g. Gengar, Makuhita'),
                      ),
                      SizedBox(height: 12.0)
                    ])))));
  }

  Future<List> fetchContent() async {
    var url = Uri.https('raw.githubusercontent.com',
        '/tsoonjin/keranamu/main/lib/config/data/treasures.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['treasures'];
    } else {
      throw Exception("Failed to fetch card collections");
    }
  }
}
