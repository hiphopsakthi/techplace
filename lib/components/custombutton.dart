import 'package:flutter/material.dart';
import 'package:techplace/screens/authentication/loginscreen.dart';

class CustomButton extends StatelessWidget {
  final lable;
  final Function() ?onpressed;
  final isloading;
  const CustomButton({Key? key, this.lable, this.onpressed, this.isloading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      child: ElevatedButton(
        onPressed:onpressed,
        child:!isloading?Text(lable,
        style: TextStyle(fontSize: 18),
        ):CircularProgressIndicator(color: Colors.white,),
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        )),
      ),
    );
  }
}
