import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:techplace/api/apifunctions.dart';
import 'package:techplace/screens/authentication/loginscreen.dart';
import 'package:techplace/screens/mainscreen.dart';

import '../../components/custombutton.dart';
import '../../components/custominput.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
bool visiblity=false;
bool isloading=false;
TextEditingController mailcontroller=TextEditingController();
TextEditingController passcontroller=TextEditingController();
TextEditingController namecontroller=TextEditingController();

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Container(
                height: 300,
                child: Image.asset("assets/bg1.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Text("Register to your Account",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                  textAlign:TextAlign.end,
                ),
              ),
              Visibility(
                  visible: visiblity,
                  child:const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Text("All Fields Required",
                      style: TextStyle(fontSize: 16,color: Colors.red),
                    ),
                  )),
              const SizedBox(height: 20,),
              CustomInput(lable: "Name",controller: namecontroller,),
              const SizedBox(height: 20,),
              CustomInput(lable: "Email Id",controller: mailcontroller,),
              const SizedBox(height: 20,),
              CustomInput(lable: "Password",obsecure: true,controller: passcontroller,),
              const SizedBox(height: 20,),
              CustomButton(lable: "Register",isloading:isloading,onpressed:register),
              const SizedBox(height: 30,),
               Text.rich(TextSpan(
                  text:"Already Have an Account? ",
                  style: TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap=(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                        },
                      text: "Login",
                      style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.bold),
                    )
                  ]
              ))
            ],
          ),
        ),
      ),
    );
  }
  register()async{
    isloading=true;
    setState(() {});
    String name=namecontroller.text;
    String pass=passcontroller.text;
    String mail=mailcontroller.text;
    if(name.isEmpty||pass.isEmpty||mail.isEmpty){
      visiblity=true;
      isloading=false;
      setState(() {});
    }
    else{
      var data=await registerapi(name,mail,pass,context);
      if(data==false){
        isloading=false;
        visiblity=true;
        setState(() {});
      }
      else{
        isloading=false;
        visiblity=false;
        mailcontroller.clear();
        passcontroller.clear();
        namecontroller.clear();
        setState(() {});
      }
    }
     }
  }

