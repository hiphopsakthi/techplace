import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techplace/models/addpostmodel.dart';
import 'package:techplace/models/profilemodel.dart';
import 'package:techplace/models/registermodel.dart';
import 'package:techplace/screens/authentication/loginscreen.dart';
import '../models/loginmodel.dart';
import '../screens/mainscreen.dart';

final dio=Dio();
Response? response;
String baseurl='http://techdotiumplace-001-site1.btempurl.com/';

Future<bool> loginapi(mail,pass,context)async{
  FormData data=FormData.fromMap({
    'email':mail,
    'password':pass
  });
   response=await dio.post(baseurl+"login.php",data: data);
   var user=LoginModel.fromJson(response!.data);
   if(user.Status==true){
     final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     sharedPreferences.setString('email',user.email.toString());
     Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
     return true;
   }
   return false;
}
Future<bool> registerapi(name,mail,pass,context)async{
  FormData data=FormData.fromMap({
    'name':name,
    'email':mail,
    'password':pass
  });
  response=await dio.post(baseurl+"signup.php",data: data);
  var user=RegisterModel.fromJson(response!.data);
  if(user.status==true){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    return true;
  }
  return false;
}
 profileapi(mail)async{
  FormData data=FormData.fromMap({
    'email':mail
  });
  response=await dio.post(baseurl+"userprofile.php",data: data);
  var user=ProfileModel.fromJson(response!.data);
  return user;
}
 upcomingapi()async{
  response=await dio.get(baseurl+"viewupcommingpost.php");
  var data=(response!.data);
  return data;
}

updateprofilepic(mail,img)async{
  FormData data=FormData.fromMap({
    'email':mail,
    'image':img
  });
  Response response=await dio.post(baseurl+"updateuserpic.php",
      data: data
  );
  print(response.data);
}

addadmin(mail)async{
  FormData data=FormData.fromMap({
    'email':mail,
    'isactive':1
  });
  Response response=await dio.post(baseurl+"addadmin.php",
      data: data
  );
  print(response.data);
}
addpostapi(name,image,des,link,dept)async{
  FormData data=FormData.fromMap({
    'postname':name,
    'postdescription':des,
    'postimage':image,
    'postlink':link,
    'dept':dept
  });
  Response response=await dio.post(baseurl+"addupcommingpost.php",
  data: data
  );
  final isadd=AddpostModel.fromJson(response.data);
  return isadd.status;
}
// http://techdotium-001-site1.itempurl.com/api/deleteupcommingpost.php
deletepostapi(id)async{
  FormData data=FormData.fromMap({
    'id':id,
  });
  Response response=await dio.post(baseurl+"deleteupcommingpost.php",
      data: data
  );
  print(response.data);
}
postlistapi(dept)async{
  FormData data=FormData.fromMap({
    'dept':dept,
  });
  Response response=await dio.post(baseurl+"upcomingpostbydept.php",
      data: data
  );
  return response.data;
}
addbanner()async{
  response=await dio.get(baseurl+"viewadbanner.php");
  var data=(response!.data);
  return data;
}
updateprofileapi(name,phone,dept,sslc,hsc,cpga,mail)async{
  FormData data=FormData.fromMap({
    'name':name,
    'email':mail,
    'sslc':sslc,
    'hsc':hsc,
    'phone':phone,
    'dept':dept,
    "cgpa":cpga
  });
  Response response=await dio.post(baseurl+"updateuserinfo.php",
      data: data
  );
  return response.data;
}
updatedata(id,name,image,des,link,dept)async{
  FormData data=FormData.fromMap({
    'id':id,
    'postname':name,
    'postdescription':des,
    'postimage':image,
    'postlink':link,
    'dept':dept
  });
  Response response=await dio.post(baseurl+"updateupcommingpost.php",
      data: data
  );
  print(response.data);
  return response.data;
}