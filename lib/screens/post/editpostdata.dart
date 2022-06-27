import 'dart:convert';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techplace/models/upcomingmodel.dart';
import '../../api/apifunctions.dart';
import '../../components/custombutton.dart';
import '../../components/customdropdown.dart';
import '../../components/custominput.dart';

class EditPostData extends StatefulWidget {
  final Function() refrech;
  final UpcomimgModel?postdata;
  const EditPostData({Key? key, required this.postdata, required this.refrech, }) : super(key: key);

  @override
  State<EditPostData> createState() => _EditPostDataState();
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
class _EditPostDataState extends State<EditPostData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postnamecontroller.text=widget.postdata!.name.toString();
    postlinkcontroller.text=widget.postdata!.link.toString();
    postdescontroller.text=widget.postdata!.description.toString();
    deptname=widget.postdata!.dept.toString();
    img64=widget.postdata!.image.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text("Edit Post",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.green[900]),
        ),
        iconTheme:const IconThemeData(
            color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              CustomInput(lable: "Name",controller:postnamecontroller,),
              const SizedBox(height: 20,),
              CustomInput(maxline: 3,lable: "Description",controller:postdescontroller,),
              const SizedBox(height: 20,),
              CustomInput( lable: "Link",controller:postlinkcontroller,),
              const SizedBox(height: 20,),
              CustomDropDown(item:deptlist,
                  lable: "Department",
                  initialvalue: deptname,
                  onchange:(value){
                    setState(() {
                      deptname=value;
                    });
                  }),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose Image',),
                  const SizedBox(height: 10,),
                  Stack(
                      alignment: Alignment.bottomRight,
                      clipBehavior: Clip.none,
                      children:[ Container(
                          height: 250,
                          width: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child:img64==null?Center(child: Text("No Image")):
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
                              child:const Icon(Icons.add),
                            ),
                          ),
                        )
                      ]
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              CustomButton(lable: "Update",onpressed: ()async{
                final id=widget.postdata!.id;
                final name=postnamecontroller.text;
                final image=img64;
                final des=postdescontroller.text;
                final link=postlinkcontroller.text;
                var dept=deptname.toString();
                isloading=true;
                setState(() {
                });
                final data=await updatedata(id,name,image,des,link,dept);
                if(data==true){
                  isloading=false;
                  _showToast(context,"Post Update");
                    widget.refrech();
                 Navigator.pop(context);
                }
                else{
                  isloading=false;
                  _showToast(context, "Server Error");
                  setState(() {
                  });
                }
              },isloading: isloading,),
              const SizedBox(height: 50,),
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
