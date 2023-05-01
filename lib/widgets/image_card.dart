import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageName;

  const ImageCard({Key? key, required this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.25,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                        child: Image.asset(
                      'images/$imageName.png',
                      height: 300,
                      width: 200,
                      fit: BoxFit.fill,
                    ))),
              ),
              SizedBox(
                height: 16,
              ),
              Flexible(
                flex: 1,
                child: Text(
                  imageName.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
