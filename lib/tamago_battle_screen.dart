import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keranamu/tamago_start_match.dart';
import 'package:keranamu/widgets/tamago_card.dart';

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

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  late Timer _timer;
  int _countdownSeconds = 3;

  List<String> randomDraft(Map<String, int> handCards) {
    List<String> randomDraft = [];
    var currHandCards = Map.of(handCards);
    for (var i = 0; i < draft.length; i++) {
      var availableCards = currHandCards.entries
          .where((MapEntry e) => e.value > 0)
          .map((MapEntry e) => e.key)
          .toList();
      int idx = Random().nextInt(availableCards.length);
      String selectedCard = availableCards[idx];
      currHandCards[selectedCard] = max(0, currHandCards[selectedCard]! - 1);
      randomDraft.add(selectedCard);
    }
    return randomDraft;
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _timer.cancel();
          var myHand = randomDraft(handCards);
          var oppHand = randomDraft(handCards);
          var currHand = Map.of(handCards);
          for (var cardKey in myHand) {
            currHand[cardKey] = max(0, currHand[cardKey]! - 1);
          }
          draft = myHand;
          handCards = currHand;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TamagoStartMatchPage(myHand: myHand, oppHand: oppHand)));
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
          Text(
            _countdownSeconds > 0
                ? 'Time left: $_countdownSeconds'
                : "Time's up",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.25, // Set a specific height
                          child: ReorderableListView.builder(
                              scrollDirection: Axis.horizontal,
                              buildDefaultDragHandles: false,
                              itemCount: draft.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ReorderableDragStartListener(
                                    index: index,
                                    key: ValueKey(index),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025),
                                        child: TamagoCard(
                                            icon: imageMap[draft[index]] ??
                                                defaultImage,
                                            onTap:
                                                onTapDraftCard(draft[index]))));
                              },
                              onReorder: (int oldIdx, int newIdx) {
                                var currDraft = List.of(draft);
                                String oldVal = currDraft[oldIdx];
                                String newVal = currDraft[newIdx];
                                currDraft[newIdx] = oldVal;
                                currDraft[oldIdx] = newVal;
                                setState(() {
                                  draft = List.of(currDraft);
                                });
                              }))
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
