import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techplace/screens/authentication/loginscreen.dart';
import 'package:techplace/screens/mainscreen.dart';

String? mail;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  mail = await sharedPreferences.getString('email');
  print(mail);
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechPlace',
      theme: ThemeData(
        backgroundColor: Colors.grey[100],
        primarySwatch: Colors.green,
      ),
      home: AnimatedSplashScreen(
        splash: SizedBox(
            width: 150,
            height: 500,
            child: Image.asset(
              'assets/intro.png',
              fit: BoxFit.fitWidth,
            )),
        nextScreen: mail == null ? const LoginScreen() : const MainScreen(),
      ),
    );
  }
}
