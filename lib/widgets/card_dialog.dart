import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TamagoMode { initial, battle, claim }

class CardDialog extends StatefulWidget {
  final String name;
  final int id;

  const CardDialog({Key? key, required this.name, required this.id})
      : super(key: key);

  @override
  State<CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  Color buttonForegroundColor = Colors.blue;
  Color buttonBackgroundColor = Colors.white;
  TamagoMode mode = TamagoMode.initial;

  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: FractionalOffset.topRight,
          child: GestureDetector(
            child: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: min(500, MediaQuery.of(context).size.width * 0.3),
            height: min(500, MediaQuery.of(context).size.height * 0.3),
            child: Column(
              children: [
                _getCloseButton(context),
                const SizedBox(height: 12),
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 12),
                Flexible(
                  flex: 1,
                  child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.25,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                          child: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.id}.png',
                        height: 300,
                        width: 200,
                        fit: BoxFit.fill,
                      ))),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  ElevatedButton(
                      onPressed: () => setState(() {
                            mode = TamagoMode.claim;
                          }),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              buttonForegroundColor),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              buttonBackgroundColor),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.blue)))),
                      child: const Text("Claim")),
                  const SizedBox(width: 32),
                  ElevatedButton(
                      onPressed: () => setState(() {
                            mode = TamagoMode.battle;
                          }),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              buttonForegroundColor),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              buttonBackgroundColor),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.blue)))),
                      child: const Text("Battle")),
                ]),
                if (mode == TamagoMode.claim) ...[
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: () => print("Submitted"),
                      child: const Text('Submit'))
                ],
              ],
            )),
      ),
    );
  }
}
