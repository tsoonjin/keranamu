import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageName;
  final int id;

  const ImageCard({Key? key, required this.imageName, required this.id})
      : super(key: key);

  void showCustomDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'This is a Custom Dialog',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You get more customisation freedom in this type of dialogs',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ),
      );

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
      child: GestureDetector(
          onTap: () => showCustomDialog(context),
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
                            child: Image.network(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
                          height: 300,
                          width: 200,
                          fit: BoxFit.fill,
                        ))),
                  ),
                  const SizedBox(
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
          )),
    );
  }
}
