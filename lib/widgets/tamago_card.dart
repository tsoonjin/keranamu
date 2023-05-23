import 'package:flutter/material.dart';

class TamagoCard extends StatelessWidget {
  final int? number;
  final Image icon;
  final Function()? onTap;

  const TamagoCard({Key? key, this.number, required this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardColor = number == 0 ? Colors.grey : Colors.white;
    Color textColor = number == 0 ? Colors.white : Colors.black;

    return GestureDetector(
        onTap: number != 0 && onTap != null ? onTap : null,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              if (number != null)
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 24,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Center(child: icon),
            ],
          ),
        ));
  }
}
