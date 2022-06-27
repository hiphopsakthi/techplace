import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techplace/components/custombutton.dart';
import 'package:techplace/components/customdropdown.dart';
import 'package:techplace/components/custominput.dart';
import 'package:techplace/models/profilemodel.dart';

import '../../api/apifunctions.dart';

class UpdateProfile extends StatefulWidget {
  final email;
  final title;
  final Function() refresh;
  const UpdateProfile({Key? key, this.title, this.email, required this.refresh}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}
TextEditingController namecontroller=TextEditingController();
TextEditingController phonecontroller=TextEditingController();
TextEditingController sslccontroller=TextEditingController();
TextEditingController hsccontroller=TextEditingController();
TextEditingController cgpacontroller=TextEditingController();

bool isloading=false;
String deptname= "CSE";
List deptlist=[
  'CSE','MECH','EEE','ECE',
];
ProfileModel? user;
class _UpdateProfileState extends State<UpdateProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 65,
        elevation: 0,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        title:Text(widget.title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.green[900]),
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
              const SizedBox(height: 30,),
              CustomInput(lable: "Name",controller: namecontroller,),
              const SizedBox(height: 20,),
              CustomInput(lable: "Phone Number",controller: phonecontroller,keytype: TextInputType.number,),
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
              CustomInput(lable: "SSLC Mark %",controller: sslccontroller,keytype: TextInputType.number),
              const SizedBox(height: 20,),
              CustomInput(lable: "HSC Mark %",controller: hsccontroller,keytype: TextInputType.number),
              const SizedBox(height: 20,),
              CustomInput(lable: "Over all CGPA",controller: cgpacontroller,keytype: TextInputType.number),
              const SizedBox(height: 30,),
              CustomButton(lable: "Update",isloading:isloading,
              onpressed: ()async{
                final name=namecontroller.text;
                final phone=phonecontroller.text;
                final dept=deptname;
                final sslc=sslccontroller.text;
                final hsc=hsccontroller.text;
                final cgpa=cgpacontroller.text;
                final mail=widget.email.toString();
                isloading=true;
                setState(() {});
                if(namecontroller.text==user!.name.toString()&&dept==user!.dept.toString()&&phonecontroller.text==user!.phone.toString()&&sslccontroller.text==user!.sslc.toString()&&hsccontroller.text==user!.hsc.toString()&&cgpacontroller.text==user!.cgpa.toString()){
                  isloading=false;
                  setState(() {});
                }
                else{
                  final data=await updateprofileapi(name,phone,dept,sslc,hsc,cgpa,mail);
                  if(data==true){
                    isloading=false;
                    _showToast(context,"Profile Updated");
                    widget.refresh();
                    Navigator.pop(context);
                  }
                  else{
                    isloading=false;
                    _showToast(context,"server Error");
                    setState(() {});
                  }
                }
              },
              ),
              const SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
  Future getuserdata() async {
    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    final email = sharedPreferences.getString('email');
    user = await profileapi(email);
    isloading = false;
    setState(() {
      namecontroller.text=user!.name.toString();
      phonecontroller.text=user!.phone.toString();
      sslccontroller.text=user!.sslc.toString();
      hsccontroller.text=user!.hsc.toString();
      cgpacontroller.text=user!.cgpa.toString();
      user!.dept==''?null:deptname=user!.dept.toString();
    });
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
