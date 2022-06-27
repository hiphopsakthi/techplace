import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final keytype;
  final lable;
  final controller;
  final obsecure;
  final maxline;
  const CustomInput({Key? key, this.lable, this.controller, this.obsecure, this.maxline, this.keytype,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(lable),
        ),
        SizedBox(height: 10,),
        Container(
          width: 300,
          height:maxline==null?45:null,
          child: TextFormField(
            controller: controller,
            keyboardType:keytype==null?null:keytype,
            maxLines:maxline==null?1:maxline,
            obscureText:obsecure==null?false:obsecure,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                )
            ),
          ),
        ),
      ],
    );
  }
}
