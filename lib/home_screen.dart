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
        backgroundColor: Colors.white60,
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.7,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2)),
                    child: Column(children: <Widget>[
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a search term',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: CustomScrollView(slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 12.0,
                                          mainAxisSpacing: 12.0),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Container(
                                        alignment: Alignment.center,
                                        color: Colors.teal[100 * (index % 9)],
                                        child: Text('Grid Item $index'),
                                      );
                                    },
                                    childCount: 20,
                                  ),
                                )
                              ])))
                    ])))));
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
