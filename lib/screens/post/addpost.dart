import 'dart:convert';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techplace/api/apifunctions.dart';
import 'package:techplace/components/custombutton.dart';
import 'package:techplace/components/customdropdown.dart';
import 'package:techplace/components/custominput.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}
TextEditingController postnamecontroller=TextEditingController();
TextEditingController postlinkcontroller=TextEditingController();
TextEditingController postdescontroller=TextEditingController();
var deptname= "All";
List deptlist=[
  'All','CSE','MECH','EEE','ECE'
];
var selectimage=null;
String img64='';
bool isloading=false;
class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text("Add Post",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.green[900]),
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              CustomInput(lable: "Name",controller:postnamecontroller,),
              SizedBox(height: 20,),
              CustomInput(maxline: 3,lable: "Description",controller:postdescontroller,),
              SizedBox(height: 20,),
              CustomInput( lable: "Link",controller:postlinkcontroller,),
              SizedBox(height: 20,),
              CustomDropDown(item:deptlist,
                  lable: "Department",
                  initialvalue: deptname,
                  onchange:(value){
                    setState(() {
                      deptname=value;
                    });
                  }),
              SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose Image',),
                  SizedBox(height: 10,),
                  Stack(
                      alignment: Alignment.bottomRight,
                      clipBehavior:Clip.none,
                      children:[ Container(
                          height: 250,
                          width: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child:selectimage==null?Center(child: Text("No Image")):
                          Image.memory(Base64Decoder().convert(img64),fit: BoxFit.fill,)
                      ),
                        Positioned(
                          bottom: -10,
                          right: -20,
                          child: Container(
                            height: 35,
                            child: FloatingActionButton(onPressed: ()async{
                              final ImagePicker _picker = ImagePicker();
                              selectimage = await _picker.pickImage(source: ImageSource.gallery);
                              final bytes = Io.File(selectimage.path).readAsBytesSync();
                              img64 = base64Encode(bytes);
                              setState((){});
                            },
                              child: Icon(Icons.add),
                            ),
                          ),
                        )
                      ]
                  ),
                ],
              ),
              SizedBox(height: 40,),
              CustomButton(lable: "ADD",onpressed: ()async{
                final name=postnamecontroller.text;
                final image=img64;
                final des=postdescontroller.text;
                final link=postlinkcontroller.text;
                var dept=deptname.toString();
                isloading=true;
                setState(() {
                });
                final data=await addpostapi(name,image,des,link,dept);
                if(data==true){
                  isloading=false;
                  _showToast(context,'Post Added');
                  postnamecontroller.clear();
                  postlinkcontroller.clear();
                  postdescontroller.clear();
                  deptname = "All";
                  selectimage=null;
                  setState(() {
                  });
                }
                else{
                  isloading=false;
                  _showToast(context,'Server Error');
                  setState(() {
                  });
                }
              },isloading: isloading,),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
  void _showToast(BuildContext context,msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
       SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(height:18,child: Center(child: Text(msg))),
      ),
    );
  }
}
