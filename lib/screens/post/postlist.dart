import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:techplace/screens/dashboard.dart';
import 'package:techplace/screens/eventscreen.dart';
import 'package:techplace/screens/post/postdetail.dart';
import '../../api/apifunctions.dart';
import '../../components/customcard.dart';
import '../../models/upcomingmodel.dart';
var datalenght = ValueNotifier<int>(0);
class PostList extends StatefulWidget {
  final List post;
  const PostList({Key? key, required this.post}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}
bool isloading=true;
class _PostListState extends State<PostList> {
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("Choose Your Career",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.green[900]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body:widget.post.length==0?Center(child: Text("No Offers Avaible",
        style: TextStyle(fontSize: 20,color: Colors.green[900]),
      )):ListView.builder(
          itemCount:widget.post.length,
          itemBuilder: (context,index){
            final detail=UpcomimgModel.fromJson(widget.post[index]);
            // print(widget.post[index]);
            // print(widget.post[index]['dept']);
            final image=Base64Decoder().convert(detail.image.toString());
            return GestureDetector(child: CustomCard(detail:detail ,image: image,),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        DetialScreen(data: detail,)));
              },
            );
          },
      )
    );
  }
}
