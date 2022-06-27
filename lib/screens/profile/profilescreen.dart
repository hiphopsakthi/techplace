import 'dart:convert';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:techplace/api/apifunctions.dart';
import 'package:techplace/components/custombutton.dart';
import 'package:techplace/components/profilecard.dart';
import 'package:techplace/components/skelton.dart';
import 'package:techplace/models/profilemodel.dart';
import 'package:techplace/screens/authentication/loginscreen.dart';
import 'package:techplace/screens/profile/updateprofile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
ProfileModel? user;
bool isloading=true;
bool isupload=false;
bool reload=true;
var image;
var email;
class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        // centerTitle: true,
        title:  Text("Profile",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.green[900]),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) =>
                    AlertDialog(
                      title:const Text("Logout"),
                      content:const Text("Are sure! Do you want to Logout ?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () async{
                            final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                            sharedPreferences.remove('email');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                          },
                          child:const Text("Logout"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child:const Text("Cancel"),
                        ),
                      ],

                    ),
              );
            }, icon: Icon(Icons.power_settings_new,color: Colors.green[900],)),
          )
        ],
        elevation: 0,
      ),
      body:RefreshIndicator(
          onRefresh:refresh,
          child:!isloading ?user!.Status==true?ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            physics:AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior:Clip.none,
                        alignment: Alignment.bottomRight,
                        children: [
                          user!.image!.isEmpty?Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey
                            ),
                            child:const Center(child: Text("No Image")),
                          ):Container(
                          height: 120,
                          width: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:Image.memory(Base64Decoder().convert(user!.image
                                .toString()), fit: BoxFit.cover,),
                          ),
                        ),
                          Positioned(right: -20,
                            bottom: -10,
                            child: Container(
                              height: 35,
                              child: FloatingActionButton(
                                onPressed: () async {
                                  bool load=false;
                                  var selectimage;
                                  String img64="";
                                   showDialog(
                                    context: context,
                                    builder: (ctx) =>
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text("Update Profile Photo"),
                                              content:!load?selectimage==null?user!.image!.isEmpty?Container(
                                                height: 120,
                                                width: 120,
                                                color: Colors.grey,
                                                child: Center(child: Text("No Image")),
                                              ):Image.memory(
                                                Base64Decoder().convert(
                                                    user!.image.toString()),
                                                fit: BoxFit.cover,
                                                height: 200,
                                                width: 200,):Image.memory(Base64Decoder().convert(img64),height: 200,
                                                width: 200,):Container(
                                                  height: 200,
                                                  width: 200,
                                                  child: Center(child: CircularProgressIndicator())),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () async{
                                                    final ImagePicker _picker = ImagePicker();
                                                    selectimage = await _picker.pickImage(source: ImageSource.gallery);
                                                    final bytes = Io.File(selectimage.path).readAsBytesSync();
                                                    img64 = base64Encode(bytes);
                                                    setState((){});
                                                  },
                                                  child: Text("Choose"),
                                                ),
                                                FlatButton(
                                                  onPressed:selectimage==null?null:()async{
                                                    setState((){
                                                      load=true;
                                                    });
                                                    isupload=true;
                                                    await updateprofilepic(user!.email, img64);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("update"),
                                                ),
                                              ],
                                            );
                                          }),
                                  ).then((value)async{
                                    if(isupload){
                                      await getuserdata();
                                      _showToast(context);
                                      isupload=false;
                                      setState(() {});
                                    }
                                        });
                                },
                                child: Icon(Icons.edit, size: 18,),
                              ),
                            ),
                          )
                        ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user!.name.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                        const SizedBox(height: 5,),
                        Text(user!.email.toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 5,),
                        Text(user!.roll == '1' ? "ADMIN" : "STUDENT",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("SETTINGS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20,),
              ProfileCard(
                title: "Update Your Profile", icon: Icons.person_sharp,
              ontap: (title){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfile(title:title,email: email,
                  refresh:refresh ,
                  )));
              },
              ),
              const SizedBox(height: 20,),
              ProfileCard(title: "Assessment", icon: Icons.star,
              ontap: (title){},
              ),
              const SizedBox(height: 20,),
              ProfileCard(title: "View Result", icon: Icons.bolt,
              ontap: (title){},
              ),
            ],
          ): Center(
              child: CustomButton(lable: "Login",isloading: false, onpressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },),
        ) :Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                         Skelton(height: 120.0,width: 120.0,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children:const [
                             Skelton(height: 10.0,width: 150.0,),
                             SizedBox(height: 10,),
                             Skelton(height: 10.0,width: 150.0,),
                             SizedBox(height: 10,),
                             Skelton(height: 10.0,width: 50.0,),
                           ],
                         ),
                        ],
                      ),
                      const SizedBox(height: 40,),
                      const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Skelton(height: 10.0,width: 70.0,),
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Skelton(height: 50.0,width:double.infinity,),
                      ),
                      const  SizedBox(height: 20,),
                      const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Skelton(height: 50.0,width:double.infinity,),
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Skelton(height: 50.0,width:double.infinity,),
                      ),


                    ],
              ) ,
    )

              );
  }
  Future getuserdata() async {
    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    email = sharedPreferences.getString('email');
    user = await profileapi(email);
    isloading = false;
    reload==true?setState(() {}):null;
    reload=false;
  }
  Future<void>refresh ()async{
    await Future.delayed(Duration(milliseconds: 1000),()async{
      await getuserdata();
      setState(() {
      });
    });
  }
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
        SnackBar(
         behavior: SnackBarBehavior.floating,
         width: 200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(height:18,child: Center(child: Text('Profile image updated'))),
      ),
    );
  }
}
