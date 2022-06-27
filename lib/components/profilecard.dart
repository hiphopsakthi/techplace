import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final title;
  final icon;
  final Function(String) ontap;
  const ProfileCard({Key? key, required this.title, required this.icon, required this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:20.0,right: 20),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 50,
                width: 50,
                decoration:BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Icon(icon,color: Colors.green,size: 30,)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                ),
              ),
            ),
            const Icon(Icons.arrow_right_outlined,size: 25,color: Colors.green,)
          ],
        ),
        onTap:(){ontap(title);},
      ),
    );
  }
}
