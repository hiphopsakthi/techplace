import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:techplace/api/apifunctions.dart';
import 'package:techplace/components/custombutton.dart';
import 'package:techplace/components/custominput.dart';
import 'package:techplace/screens/authentication/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
bool visiblity=false;
bool isloading=false;
TextEditingController mailcontroller=TextEditingController();
TextEditingController passcontroller=TextEditingController();
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        final pop=await showDialog(context: context,
            builder: (context){
              return AlertDialog(
                title:const Center(child:  Text("Are you Sure !")),
                content:Text("Do you want to Exit ?"),
                actions: [
                  FlatButton(onPressed:(){
                    Navigator.pop(context,true);
                  }, child:const Text("Exit")),
                  FlatButton(onPressed:(){
                    Navigator.pop(context,false);
                  }, child:const Text("Cancel"))
                ],
              );
            }
        );
        return pop;
      },
      child: Scaffold(
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
                  const Padding(
                    padding: EdgeInsets.only(left:20.0),
                    child: Text("Login to your Account",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                      textAlign:TextAlign.end,
                    ),
                  ),
                  Visibility(
                      visible: visiblity,
                      child:const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Text("Invaild Credentials",
                          style: TextStyle(fontSize: 16,color: Colors.red),
                        ),
                      )),
                  const SizedBox(height: 30,),
                  CustomInput(lable: "Email Id",controller: mailcontroller,),
                  const SizedBox(height: 30,),
                  CustomInput(lable: "Password",obsecure: true,controller: passcontroller,),
                  const SizedBox(height: 30,),
                  CustomButton(lable: "Login",isloading:isloading,onpressed:login),
                  const SizedBox(height: 30,),
                  Text.rich(TextSpan(
                    text:"Don't Have an Account? ",
                      style: TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                        },
                        text: "Register",
                  style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.bold),
                  )
                    ]
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
  login()async{
    isloading=true;
    setState(() {});
    String mail=mailcontroller.text;
    String pass=passcontroller.text;
    if(mail.isEmpty||pass.isEmpty){
      visiblity=true;
      isloading=false;
      mailcontroller.clear();
      passcontroller.clear();
      setState(() {});
    }
    else{
      var data=await loginapi(mail,pass,context);
      if(data==false){
        visiblity=true;
        isloading=false;
        setState(() {});
      }
      else{
        isloading=false;
        visiblity=false;
        mailcontroller.clear();
        passcontroller.clear();
        setState(() {});
      }
     }
    }
  }
