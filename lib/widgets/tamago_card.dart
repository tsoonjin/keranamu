import 'dart:math';
import 'package:flutter/material.dart';

class TamagoCard extends StatefulWidget {
  final int? number;
  final double? height;
  final double? width;
  final Image icon;
  final bool? isFront;
  final Function()? onTap;

  const TamagoCard(
      {Key? key,
      this.number,
      required this.icon,
      this.onTap,
      this.isFront,
      this.height,
      this.width})
      : super(key: key);

  @override
  State<TamagoCard> createState() => _TamagoCardState();
}

class _TamagoCardState extends State<TamagoCard> with TickerProviderStateMixin {
  late AnimationController controller;
  late bool isFront;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFront = widget.isFront ?? false;
      controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1500));
    });
  }

  Future flipCard() async {
    isFront = !isFront;
    await controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isFrontImage(double angle) {
    const degree90 = pi / 4;
    bool isFront = angle <= degree90;
    print("Is Front: $isFront, Angle: $angle");
    return isFront;
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = widget.number == 0 ? Colors.grey : Colors.white;
    Color textColor = widget.number == 0 ? Colors.white : Colors.black;

    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * -(pi / 2);
          final transform = Matrix4.identity()..rotateY(angle);

          return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: !isFrontImage(angle.abs())
                  ? GestureDetector(
                      onTap: widget.number != 0 && widget.onTap != null
                          ? widget.onTap
                          : null,
                      child: Container(
                        height: widget.height ??
                            MediaQuery.of(context).size.height * 0.25,
                        width: widget.width ??
                            MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            if (widget.number != null)
                              Positioned(
                                top: 8.0,
                                right: 8.0,
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    '${widget.number}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            Center(child: widget.icon),
                          ],
                        ),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        await flipCard();
                      },
                      child: Container(
                          height: widget.height ??
                              MediaQuery.of(context).size.height * 0.25,
                          width: widget.width ??
                              MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(16.0))));
        });
  }
}
