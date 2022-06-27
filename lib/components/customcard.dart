import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final detail;
  final image;
  const CustomCard({Key? key, this.detail, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: Image.memory(image).image,
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.name.toString(),
                      style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                    ),
                    const SizedBox(height: 10,),
                    Text(detail.description.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style:const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
