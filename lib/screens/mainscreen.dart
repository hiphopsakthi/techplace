import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:techplace/screens/dashboard.dart';
import 'package:techplace/screens/eventscreen.dart';
import 'package:techplace/screens/profile/profilescreen.dart';

import 'package:techplace/screens/resultscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

List Pages = [
  const DashboardScreen(),
  const EventScreen(),
  const ResultScreen(),
  const ProfileScreen(),
];
int Index = 0;

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final pop = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Center(child: Text("Are you Sure !")),
                content: Text("Do you want to Exit ?"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Exit")),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("Cancel"))
                ],
              );
            });
        return pop;
      },
      child: Scaffold(
        extendBody: true,
        body: Pages[Index],
        bottomNavigationBar: Theme(
          data: ThemeData(iconTheme: IconThemeData(color: Colors.green)),
          child: CurvedNavigationBar(
            height: 65,
            color: Colors.grey[300]!,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: Colors.green[100],
            animationDuration: const Duration(milliseconds: 300),
            index: Index,
            onTap: (currentindex) {
              setState(() {
                Index = currentindex;
              });
            },
            items: const [
              Icon(
                Icons.speed_outlined,
                size: 32,
              ),
              Icon(Icons.bolt, size: 32),
              Icon(Icons.search_sharp, size: 32),
              Icon(Icons.person_sharp, size: 32)
            ],
          ),
        ),
      ),
    );
  }
}
// Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children:[
// Text("Your Account has been deleted"),
// SizedBox(height: 20,),
// CustomButton(lable: "Register",isloading: false, onpressed: () {
// Navigator.push(
// context, MaterialPageRoute(builder: (context) => RegisterScreen()));
// },),
// ],
// ),),
