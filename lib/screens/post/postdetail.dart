import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:techplace/models/upcomingmodel.dart';

class DetialScreen extends StatefulWidget {
  final UpcomimgModel data;
  const DetialScreen({Key? key,required this.data}) : super(key: key);

  @override
  State<DetialScreen> createState() => _DetialScreenState();
}

class _DetialScreenState extends State<DetialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        iconTheme:const IconThemeData(
          color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 230,
              padding:const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(Base64Decoder().convert(widget.data.image.toString()),fit: BoxFit.fill,)),
              ),
            ),
            const SizedBox(height: 10,),
            Text(widget.data.name.toString(),
              style:const TextStyle(fontSize: 22,fontWeight: FontWeight.w600,),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Description",
                      style:TextStyle(fontSize: 17,fontWeight: FontWeight.w600,),
                    ),
                    const SizedBox(height: 10,),
                    Text(widget.data.description.toString(),
                      style: TextStyle(fontSize: 16,color: Colors.grey[700]
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10,),
                    const Text("Register Link",
                      style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600, ),
                    ),
                    const SizedBox(height: 10,),
                    Text(widget.data.link.toString(),
                      style:const TextStyle(color: Colors.blue),
                    )
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
