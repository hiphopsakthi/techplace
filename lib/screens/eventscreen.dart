import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../api/apifunctions.dart';
import '../models/upcomingmodel.dart';
import 'post/postdetail.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}
List data=[];
bool reload=true;
class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                toolbarHeight: 60,
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
                elevation: 0,
                title:  Text("Grab Opportunity !",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.green[900]),
                ),
                actions: [
                  Padding(
                    padding:const EdgeInsets.only(right: 15.0),
                    child:IconButton(onPressed: (){},
                        icon: Icon(Icons.search_rounded,color: Colors.green[900],)
                    )
                  )
                ],
              )
            ];
          },
          body:SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/1.1,
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio:1.0
                    ),
                    children:data.map((e){
                      final event=UpcomimgModel.fromJson(e);
                      final image=Base64Decoder().convert(event.image.toString());
                      return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetialScreen(data:event,)));
                          },
                          child: Image.memory(image,fit: BoxFit.cover,));
                    }).toList()
                  ),
                ),
                // StaggeredGrid.count(
                //         crossAxisCount: 4,
                //         mainAxisSpacing: 4,
                //         crossAxisSpacing: 4,
                //         children:data.map((e){
                //           final event=UpcomimgModel.fromJson(e);
                //           final image=Base64Decoder().convert(event.image.toString());
                //           return StaggeredGridTile.count(
                //             crossAxisCellCount: 2,
                //             mainAxisCellCount: 2,
                //             child:Image.memory(image,fit: BoxFit.fill,),
                //           );
                //         }).toList()
                //       ),
                SizedBox(height:65,)
              ],
            ),
          ),
      ),
    );
  }
   getdata()async {
    data = await upcomingapi();
    reload==true?setState(() {}):null;
    reload=false;
  }
}
