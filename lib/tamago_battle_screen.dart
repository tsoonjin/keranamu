import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keranamu/widgets/tamago_card.dart';

import 'entity/tamago_listing_cubit.dart';

class TamagoBattlePage extends StatefulWidget {
  const TamagoBattlePage({super.key});

  @override
  State<TamagoBattlePage> createState() => _TamagoBattlePageState();
}

class _TamagoBattlePageState extends State<TamagoBattlePage> {
  Image defaultImage = Image.network(
      'https://cdn-icons-png.flaticon.com/512/3524/3524344.png',
      height: 200,
      width: 200);

  Map<String, Image> imageMap = {
    'scissors': Image.network(
        'https://cdn-icons-png.flaticon.com/512/68/68847.png',
        height: 200,
        width: 200),
    'rock': Image.network(
        'https://static.vecteezy.com/system/resources/thumbnails/002/103/779/small/clenched-fist-black-glyph-icon-vector.jpg',
        height: 200,
        width: 200),
    'paper': Image.network(
        'https://cdn-icons-png.flaticon.com/512/142/142175.png',
        height: 200,
        width: 200),
    'dragon': Image.network(
        'https://cdn-icons-png.flaticon.com/512/2119/2119228.png',
        height: 200,
        width: 200),
    'rabbit': Image.network(
        'https://cdn-icons-png.flaticon.com/512/802/802338.png',
        height: 200,
        width: 200),
  };

  Map<String, int> handCards = {
    'scissors': 3,
    'rock': 3,
    'paper': 3,
    'dragon': 1,
    'rabbit': 1
  };

  List<String> draft = ["", "", "", "", ""];

  // ignore: prefer_function_declarations_over_variables
  Function() onTapHandCard(String cardKey) {
    return () {
      var currHandCards = Map.of(handCards);
      if (currHandCards.containsKey(cardKey)) {
        currHandCards[cardKey] = max(0, currHandCards[cardKey]! - 1);
      }
      setState(() {
        handCards = Map.of(currHandCards);
      });
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              color: const Color(0xFFF5F0BB),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text(
                        'Draft',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: draft.map((String e) {
                          return TamagoCard(icon: defaultImage);
                        }).toList(),
                      )
                    ],
                  ))),
          Container(
              color: const Color(0xFFFDCEDF),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text(
                        'Hand',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: handCards.entries.map((MapEntry e) {
                            return TamagoCard(
                                number: e.value,
                                icon: imageMap[e.key] ?? defaultImage,
                                onTap: onTapHandCard(e.key));
                          }).toList())
                    ],
                  ))),
        ],
      ),
    ));
  }
}
