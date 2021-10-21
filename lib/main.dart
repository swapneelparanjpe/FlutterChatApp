import 'package:chat_app/helpers/authenticate.dart';
import 'package:chat_app/helpers/prefs.dart';
import 'package:chat_app/views/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoggedIn = false;

  Future checkIfUserIsLoggedIn() async {
    await Prefs.getPrefIsLoggedIn().then((value) {
      setState(() {
        isLoggedIn = value!;
      });
    });
  }

  @override
  void initState() {
    checkIfUserIsLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red,
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}

