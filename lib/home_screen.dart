import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:f_logs/f_logs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List treasures = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextField(
            decoration:
                InputDecoration(hintText: "e.g. Aaron, Kadabra, Gengar")));
    return Scaffold(
        backgroundColor: Colors.white60,
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.7,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2)),
                    child: Column(
                        children: const <Widget>[SizedBox(height: 12.0)])))));
  }

  void fetchContent() {
    var url = Uri.https('raw.githubusercontent.com',
        '/tsoonjin/keranamu/main/lib/config/data/treasures.json');
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        var data = jsonDecode(value.body);
        treasures = data['treasures'];

        setState(() {});

        FLog.info(text: treasures.toString());
      }
    }).catchError((e) {
      FLog.error(text: "Failed to fetch data");
    });
  }
}
