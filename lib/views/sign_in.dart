import 'package:chat_app/helpers/prefs.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_room.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final AuthServices _authServices = AuthServices();
  final DatabaseServices _databaseServices = DatabaseServices();
  bool isLoading = false;

  void performUserSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true );
      dynamic result = await _authServices.signInWithEmailAndPassword(email.text, password.text);
      if (result != null) {
        QuerySnapshot searchResults = await _databaseServices.getUserByEmail(email.text);
        await Prefs.setPrefUsername(searchResults.docs[0].get("username"));
        await Prefs.setPrefEmail(searchResults.docs[0].get("email"));
        await Prefs.setPrefIsLoggedIn(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(
          backgroundColor: Colors.red[800],
          title: Text("Chat App"),
        ),
        body: isLoading ? loadingScreen() : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 64.0,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!) ? null : "Please provide a valid email";
                        },
                        controller: email,
                        style: textStyle(),
                        decoration: textFieldInputDecoration("Enter email"),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        validator: (val) => (val!.length < 6) ? "Please provide password with more than 6 characters" : null,
                        controller: password,
                        obscureText: true,
                        style: textStyle(),
                        decoration: textFieldInputDecoration("Enter password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 64.0),
                GestureDetector(
                  onTap: () async {
                    performUserSignIn();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red[600],
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          )
                      )
                  ),
                ),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: textStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Register now",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
