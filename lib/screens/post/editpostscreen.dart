import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:techplace/components/customcard.dart';
import 'package:techplace/components/skelton.dart';
import 'package:techplace/screens/post/editpostdata.dart';
import '../../api/apifunctions.dart';
import '../../models/upcomingmodel.dart';

var datalenght = ValueNotifier<int>(0);

class EditpostScreen extends StatefulWidget {
  const EditpostScreen({Key? key}) : super(key: key);

  @override
  State<EditpostScreen> createState() => _EditpostScreenState();
}
List data=[];
bool isloading=true;
bool reload=true;
class _EditpostScreenState extends State<EditpostScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("Your Post",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.green[900]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body:!isloading?RefreshIndicator(
        onRefresh: refresh,
        child: ValueListenableBuilder(
          valueListenable: datalenght,
          builder: (context, value, widget)=>ListView.builder(
            itemCount:data.length,
            itemBuilder: (context,index){
              final detail=UpcomimgModel.fromJson(data[index]);
              final image=Base64Decoder().convert(detail.image.toString());
              return Dismissible(
                key:Key(detail.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction)async{
                  await deletepostapi(detail.id);
                  _showToast(context,"deleted...");
                  setState(() {
                    data.removeAt(index);
                  });
                },
                child:GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPostData(postdata:detail,
                        refrech:refresh
                      )));
                    },
                    child: CustomCard(detail: detail,image: image,)),
              );
            },
          ),
        ),
      ):ListView.builder(
        itemCount: 3,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Skelton(
              height: 100.0,
            ),
          );
        },
      ),
    );
  }
  Future<void> refresh()async{
    await Future.delayed(Duration(seconds: 1),()async{
      await getdata();
      setState(() {
      });
    });
  }
  getdata()async {
    data = await upcomingapi();
    isloading=false;
    datalenght.value==data.length?null:datalenght.value=data.length;
    reload==true?setState(() {}):null;
    reload=false;
  }
  void _showToast(BuildContext context,data) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
       SnackBar(
         behavior: SnackBarBehavior.floating,
         width: 200,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(height:18,child: Center(child: Text(data.toString()))),
      ),
    );
  }
}