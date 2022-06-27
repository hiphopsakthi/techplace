import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:techplace/api/apifunctions.dart';
import 'package:techplace/components/custominput.dart';
import 'package:techplace/components/skelton.dart';
import 'package:techplace/models/profilemodel.dart';
import 'package:techplace/models/upcomingmodel.dart';
import 'package:techplace/screens/post/addpost.dart';
import 'package:techplace/screens/post/editpostscreen.dart';
import 'package:techplace/screens/post/postlist.dart';
import 'package:techplace/screens/profile/profilescreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'post/postdetail.dart';

var datalenght = ValueNotifier<int>(0);
var adslenght = ValueNotifier<int>(0);
var profilelen = ValueNotifier<int>(0);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

List data = [];
List ads = [];
bool carousleload = true;
bool upcomingload = true;
bool deptload = true;
var userimage = '';
var username = '';
var roll = 0;
TextEditingController mailcontroller = TextEditingController();
List dept = [
  {"dept": "CSE", "icon": Icons.computer},
  {"dept": "MECH", "icon": Icons.settings},
  {"dept": "EEE", "icon": Icons.electrical_services_sharp},
  {"dept": "ECE", "icon": Icons.settings_input_component_sharp}
];
void _launchUrl() async {
  if (!await launchUrl(Uri.parse('https://techdotium.com'))) throw 'Could not launch https://techdotium.com';
}
class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
    getads();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
        valueListenable: profilelen,
        builder: (context, value, widget) => Container(
          child: roll == 1
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 65.0),
                  child: SpeedDial(
                    child: const Icon(Icons.bar_chart),
                    children: [
                      SpeedDialChild(
                          child: const Icon(Icons.add),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddPostScreen()));
                          }),
                      SpeedDialChild(
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditpostScreen()));
                          }),
                      SpeedDialChild(
                          child: const Icon(Icons.verified_user),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        const Center(child: Text("Add Admin")),
                                    content: Container(
                                        height: 80,
                                        child: CustomInput(
                                          lable: "Email Id",
                                          controller: mailcontroller,
                                        )),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            final mail = mailcontroller.text;
                                            addadmin(mail);
                                            _showToast(context);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("ADD")),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("CANCEL")),
                                    ],
                                  );
                                });
                          }),
                    ],
                  ),
                )
              : null,
        ),
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              // snap: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "Build Your Career !",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.green[900]),
              ),
              actions: [
                // IconButton(onPressed:(){
                //   _launchUrl();
                // }, icon: Icon(Icons.image)),
                ValueListenableBuilder(
                  valueListenable: profilelen,
                  builder: (context, value, widget) => Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: userimage == ''
                        ? CircleAvatar(
                            child: Text(
                              username == '' ? "" : username[0].toString(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: Image.memory(
                              Base64Decoder().convert(userimage.toString()),
                              fit: BoxFit.cover,
                            ).image,
                          ),
                  ),
                )
              ],
            )
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 1000), () async {
              await getuserdata();
              await getdata();
              await getads();
              setState(() {
              });
            });
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: adslenght,
                  builder: (context, value, widget) => carousleload == true
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[500]!,
                          highlightColor: Colors.grey[100]!,
                          child: CarouselSlider(
                            options:
                                CarouselOptions(autoPlay: true, height: 180),
                            items: const [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Skelton(
                                  height: 180.0,
                                  width: double.infinity,
                                ),
                              )
                            ],
                          ),
                        )
                      : CarouselSlider(
                          options: CarouselOptions(autoPlay: true, height: 180),
                          items: ads.map((e) {
                            final image = Base64Decoder().convert(e);
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0, left: 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        image,
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ),
                            );
                          }).toList()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Departments",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.green[900]),
                  ),
                ),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dept.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    dept[index]['icon'],
                                    size: 35,
                                  ),
                                  Text(
                                    dept[index]['dept'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            final list = [];
                            for (var i in data) {
                              if (i['dept'] == dept[index]['dept'] ||
                                  i['dept'] == 'All') {
                                print(i['dept']);
                                list.add(i);
                              }
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostList(
                                          post: list,
                                        )));
                          },
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.green[900]),
                  ),
                ),
                SizedBox(
                    height: 150,
                    child: ValueListenableBuilder(
                      valueListenable: datalenght,
                      builder: (context, value, widget) =>upcomingload==true?
                          ListView.builder(
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder:(context,index){
                            return const Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Skelton(
                                width: 200.0,
                                height: 100.0,
                              ),
                            );
                          })
                          :ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length >= 4 ? 4 : data.length,
                          itemBuilder: (context, index) {
                            final detail = UpcomimgModel.fromJson(data[index]);
                            final image = Base64Decoder()
                                .convert(detail.image.toString());
                            return GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 6.5),
                                      child: SizedBox(
                                        width: 200,
                                        child: Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.memory(
                                                image,
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetialScreen(
                                                    data: detail,
                                                  )));
                                    },
                                  );
                          }),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Result",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.green[900]),
                  ),
                ),
                SizedBox(
                  height: 360,
                  child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ValueListenableBuilder(
                            valueListenable: adslenght,
                            builder: (context, value, widget) =>carousleload  ==
                                    true
                                ? const Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Skelton(
                                      height: 130.0,
                                      width: double.infinity,
                                    ),
                                  )
                                : SizedBox(
                                    height: 130,
                                    child: Card(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 40,
                                                backgroundImage: NetworkImage(
                                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_CeONd9C4Tr6zE0bHO6WldlLmlhYQiggSltqJWRiXe3aSeRwrrx-mK4jxWSFnPvXK2QI&usqp=CAU')),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "TCS Ninja",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Conducted on 18/04/2022",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "View",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ));
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getdata() async {
    data = await upcomingapi();
    if (datalenght.value == data.length) {
      return null;
    } else {
      upcomingload = false;
      datalenght.value = data.length;
    }
  }

  getuserdata() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final mail = sharedPreferences.getString('email');
    ProfileModel image = await profileapi(mail);
    roll = int.parse(image.roll.toString());
    if (userimage == image.image.toString()) {
      return null;
    } else {
      userimage = image.image.toString();
      profilelen.value++;
    }
    username = image.name.toString();
  }

  getads() async {
    ads = await addbanner();
    if (adslenght.value == ads.length) {
      return null;
    } else {
      carousleload = false;
      adslenght.value = ads.length;
    }
  }
}

void _showToast(BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    const SnackBar(
      content: Text('Admin Added'),
    ),
  );
}
