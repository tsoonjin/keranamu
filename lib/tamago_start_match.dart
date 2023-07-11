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

class _TamagoStartMatchPageState extends State<TamagoStartMatchPage>
    with TickerProviderStateMixin {
  int animateHandIdx = 1;
  final double maxOffset = 400;
  late AnimationController _controller;
  late AnimationController _cardFlipController;
  late Animation<double> animation;
  late List<Animation> cardAnimations;
  late List<double> rotateAngles;

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
    rotateAngles =
        List<double>.generate(widget.myHand.length, (int index) => 0.0);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _cardFlipController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10000));
    cardAnimations = [
      for (var i = 0; i < widget.myHand.length; i += 1)
        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _cardFlipController,
            curve: Interval(i * 1 / (widget.myHand.length + 1),
                (i + 1) * 1 / (widget.myHand.length + 1),
                curve: Curves.linear)))
    ];
    print(cardAnimations);
    animation = Tween(begin: 0.0, end: maxOffset).animate(_controller);
    _cardFlipController.addListener(() {
      // print(cardAnimations.map((i) => i.value));
      rotateAngles = [
        for (var i = 0; i < widget.myHand.length; i += 1)
          cardAnimations[i].value
      ];
      setState(() {
        rotateAngles = rotateAngles;
      });
    });
    _cardFlipController.addStatusListener((status) {
      if (status != AnimationStatus.completed) {
        print("Flippening: ${DateTime.now().toString()}");
      }
      if (status == AnimationStatus.completed) {
        print("Done flipping: ${DateTime.now().toString()}");
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
      print("Animated Idx: $animateHandIdx");
      if (animateHandIdx == widget.myHand.length) {
        print("Flip the burger");
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
                      const Text(
                        'Opponent',
                        style: TextStyle(
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
                                              shouldClose:
                                                  rotateAngles[idx] < 1,
                                              cardController:
                                                  _cardFlipController,
                                              rotateAngle: rotateAngles[idx],
                                              icon:
                                                  imageMap[e] ?? defaultImage));
                                    }).toList());
                                  })))
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
                                              shouldClose:
                                                  rotateAngles[idx] < 1,
                                              cardController:
                                                  _cardFlipController,
                                              rotateAngle: rotateAngles[idx],
                                              icon:
                                                  imageMap[e] ?? defaultImage));
                                    }).toList());
                                  })))
                    ],
                  ))),
        ],
      ),
    ));
  }
}
