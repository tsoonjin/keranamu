import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keranamu/widgets/tamago_card.dart';
import 'package:collection/collection.dart';

class TamagoStartMatchPage extends StatefulWidget {
  List<String> myHand;
  List<String> oppHand;

  TamagoStartMatchPage({Key? key, required this.myHand, required this.oppHand})
      : super(key: key);

  @override
  State<TamagoStartMatchPage> createState() => _TamagoStartMatchPageState();
}

class _TamagoStartMatchPageState extends State<TamagoStartMatchPage>
    with TickerProviderStateMixin {
  String battleText = "Let's battle ⚔️";
  int animateHandIdx = 1;
  int battleIdx = -1;
  List<int> oppScores = [];
  List<int> myScores = [];
  int myScore = 0;
  int oppScore = 0;
  final double maxOffset = 400;
  late AnimationController _controller;
  late AnimationController _cardFlipController;
  late Animation<double> animation;
  late Animation<double> cardAnimation;
  double rotateAngle = 0.0;
  List<List<int>> cardBattleScores = [
    [1, 0, 2, -1, 3],
    [2, 1, 0, -1, 3],
    [0, 2, 1, -1, 3],
    [3, 3, 3, 1, -2],
    [-2, -2, -2, 4, 1],
  ];

  Image defaultImage = Image.network(
      'https://cdn-icons-png.flaticon.com/512/3524/3524344.png',
      height: 200,
      width: 200);

  Map<String, String> imagePathMap = {
    'scissors': 'https://cdn-icons-png.flaticon.com/512/68/68847.png',
    'rock':
        'https://static.vecteezy.com/system/resources/thumbnails/002/103/779/small/clenched-fist-black-glyph-icon-vector.jpg',
    'paper': 'https://cdn-icons-png.flaticon.com/512/142/142175.png',
    'dragon': 'https://cdn-icons-png.flaticon.com/512/2119/2119228.png',
    'rabbit': 'https://cdn-icons-png.flaticon.com/512/802/802338.png',
  };

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

  Map<String, int> cardTypeToIdx = {
    'scissors': 0,
    'rock': 1,
    'paper': 2,
    'dragon': 3,
    'rabbit': 4
  };

  List<String> draft = ["", "", "", "", ""];

  @override
  void initState() {
    super.initState();
    for (final pair in IterableZip([widget.myHand, widget.oppHand])) {
      int myHandIdx = cardTypeToIdx[pair[0]]!;
      int oppHandIdx = cardTypeToIdx[pair[1]]!;
      myScores.add(cardBattleScores[myHandIdx][oppHandIdx]);
      oppScores.add(cardBattleScores[oppHandIdx][myHandIdx]);
    }
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _cardFlipController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    cardAnimation = Tween(begin: 0.0, end: 1.0).animate(_cardFlipController);
    animation = Tween(begin: 0.0, end: maxOffset).animate(_controller);
    _cardFlipController.addListener(() {
      setState(() {
        rotateAngle = cardAnimation.value;
      });
    });
    _cardFlipController.addStatusListener((status) {
      if (status != AnimationStatus.completed) {}
      if (status == AnimationStatus.completed &&
          battleIdx < widget.myHand.length) {
        setState(() {
          myScore += myScores[battleIdx];
          oppScore += oppScores[battleIdx];
        });
        if (battleIdx == widget.myHand.length - 1) {
          String gameOverText = "It's a draw";
          if (myScore != oppScore) {
            gameOverText = "You ${myScore > oppScore ? 'win 🎉' : 'lose ☹️'}";
          }
          setState(() {
            battleText = gameOverText;
            battleIdx++;
          });
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            _cardFlipController.forward(from: 0.0);
            battleIdx++;
          });
        }
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          animateHandIdx < widget.myHand.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _controller.forward(from: 0.0);
          animateHandIdx++;
        });
      }
      if (animateHandIdx == widget.myHand.length) {
        print("Flip the burger");
        battleIdx = 0;
        _cardFlipController.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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

  Image getImage(String myCard, String oppCard, int battleIdx, int cardIdx) {
    return Image.network(imagePathMap[myCard]!,
        height: 200,
        width: 200,
        opacity: cardIdx < battleIdx &&
                cardBattleScores[cardTypeToIdx[myCard]!]
                        [cardTypeToIdx[oppCard]!] <=
                    cardBattleScores[cardTypeToIdx[oppCard]!]
                        [cardTypeToIdx[myCard]!]
            ? const AlwaysStoppedAnimation(0.4)
            : const AlwaysStoppedAnimation(1.0));
  }

  double calculateOffset(
      int idx, int animateHandIdx, double animationVal, double maxOffset) {
    double offset = maxOffset * idx;
    if (idx < animateHandIdx) {
      return offset;
    } else if (idx == animateHandIdx) {
      return animationVal * idx;
    } else {
      return 0;
    }
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
                      Text(
                        'Opponent: $oppScore',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Stack(
                                        children: widget.oppHand
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                      int idx = entry.key;
                                      String e = entry.value;
                                      return Transform.translate(
                                          offset: Offset(
                                              calculateOffset(
                                                  idx,
                                                  animateHandIdx,
                                                  animation.value,
                                                  maxOffset),
                                              0),
                                          child: TamagoCard(
                                              shouldClose: idx >= battleIdx,
                                              cardController:
                                                  _cardFlipController,
                                              rotateAngle: battleIdx == idx
                                                  ? rotateAngle
                                                  : 0,
                                              icon: getImage(
                                                  widget.oppHand[idx],
                                                  widget.myHand[idx],
                                                  battleIdx,
                                                  idx)));
                                    }).toList());
                                  })))
                    ],
                  ))),
          Text(battleText,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 64)),
          Container(
              color: const Color(0xFFFDCEDF),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        'Me: $myScore',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Stack(
                                        children: widget.myHand
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                      int idx = entry.key;
                                      String e = entry.value;
                                      return Transform.translate(
                                          offset: Offset(
                                              calculateOffset(
                                                  idx,
                                                  animateHandIdx,
                                                  animation.value,
                                                  maxOffset),
                                              0),
                                          child: TamagoCard(
                                              shouldClose: idx >= battleIdx,
                                              cardController:
                                                  _cardFlipController,
                                              rotateAngle: battleIdx == idx
                                                  ? rotateAngle
                                                  : 0,
                                              icon: getImage(
                                                  widget.myHand[idx],
                                                  widget.oppHand[idx],
                                                  battleIdx,
                                                  idx)));
                                    }).toList());
                                  })))
                    ],
                  ))),
        ],
      ),
    ));
  }
}
