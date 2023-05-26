import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keranamu/widgets/tamago_card.dart';

class TamagoStartMatchPage extends StatefulWidget {
  List<String> myHand;
  List<String> oppHand;

  TamagoStartMatchPage({Key? key, required this.myHand, required this.oppHand})
      : super(key: key);

  @override
  State<TamagoStartMatchPage> createState() => _TamagoStartMatchPageState();
}

class _TamagoStartMatchPageState extends State<TamagoStartMatchPage> {
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

  @override
  void initState() {
    super.initState();
  }

  // ignore: prefer_function_declarations_over_variables
  Function() onTapDraftCard(String cardKey) {
    return () {
      var currHandCards = Map.of(handCards);
      var currDraftCards = List.of(draft);
      int currIndex = currDraftCards.indexOf(cardKey);

      if (cardKey != "") {
        currHandCards[cardKey] = currHandCards[cardKey]! + 1;
        currDraftCards[currIndex] = "";
      }

      setState(() {
        handCards = Map.of(currHandCards);
        draft = List.of(currDraftCards);
      });
    };
  }

  // ignore: prefer_function_declarations_over_variables
  Function() onTapHandCard(String cardKey) {
    return () {
      var currHandCards = Map.of(handCards);
      var currDraftCards = List.of(draft);
      int firstAvailableSlot = currDraftCards.indexOf("");

      if (currHandCards.containsKey(cardKey) && firstAvailableSlot >= 0) {
        currHandCards[cardKey] = max(0, currHandCards[cardKey]! - 1);
        currDraftCards[firstAvailableSlot] = cardKey;
      }

      setState(() {
        handCards = Map.of(currHandCards);
        draft = List.of(currDraftCards);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              color: const Color(0xFFFDCEDF),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text(
                        'Opponent',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: widget.oppHand.map((String e) {
                            return TamagoCard(
                                icon: imageMap[e] ?? defaultImage);
                          }).toList())
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
                        'Me',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: widget.myHand.map((String e) {
                            return TamagoCard(
                                icon: imageMap[e] ?? defaultImage);
                          }).toList())
                    ],
                  ))),
        ],
      ),
    ));
  }
}
