import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:techplace/components/customcard.dart';
import 'package:techplace/contants.dart';
import 'package:techplace/models/upcomingmodel.dart';
import '../api/apifunctions.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}
List data=[];
List listdata=[];
class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              title: Text("Search Materials !",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.green[900]),
              ),
              actions: [
                IconButton(onPressed: () {
                  showSearch(context: context, delegate: Search());
                }, icon: Icon(Icons.search, color: Colors.green[900],))
              ],
            )
          ];
        },
        body:ListView.builder(
          itemCount: 4,
          itemBuilder: (context,index){
            final img=base64.decode(Contants.image);
            return CustomCard(detail:UpcomimgModel.fromJson({'name':"TCS Study Material",'description':'To Crack the TCS Ninja and TCS Digital'}),
            image:img,
            );
          },
        )
      ),
    );
  }
  getdata() async {
    data = await upcomingapi();
  }
}
class Search extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query='';
      }, icon: Icon(Icons.cancel))
    ];
  }
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed:(){
      Navigator.pop(context);
    }, icon: AnimatedIcon(
      icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation,
    ));
  }
  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        itemCount: listdata.length,
        itemBuilder: (context, index){
          final image=base64Decode(listdata[index]['image']);
          return Image.memory(image);
        });
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List nodata=['Zoho','Infosys','MindTree'];
    listdata=data.where((element)=>element['name'].startsWith(query.toUpperCase())).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:20.0,left: 20,right: 20),
          child: Text(query.isEmpty?'Top Search':"Result",
            style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black),),
        ),
        Expanded(
          child: ListView.builder(
            itemCount:query.isEmpty?nodata.length:listdata.length,
            itemBuilder: (context, index){
              if(query.isEmpty){
                return GestureDetector(
                  onTap: (){
                    query=nodata[index];
                  },
                  child: Padding(
                    padding:const EdgeInsets.only(top:20.0,left: 20,right: 20),
                    child: Text(nodata[index],
                      style:const TextStyle(
                          fontSize: 17,
                          color: Colors.black),
                    ),
                  ),
                );
              }
              else{
                return GestureDetector(
                  onTap: (){
                    query=listdata[index]['name'];
                  },
                  child: Padding(
                    padding:const EdgeInsets.only(top:20.0,left: 20,right: 20),
                    child: Text(listdata[index]['name'],
                      style:const TextStyle(
                          fontSize: 17,
                          color: Colors.black),
                    ),
                  ),
                );
              }
            }),
        ),
      ],
    );
  }
}
