import 'package:chat_app/helpers/prefs.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chat_room.dart';

class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp({ required this.toggleView });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final AuthServices _authServices = AuthServices();
  final DatabaseServices _databaseServices = DatabaseServices();
  bool isLoading = false;

  void performUserSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true );
      dynamic result = await _authServices.createUserWithEmailAndPassword(email.text, password.text);
      if (result != null) {
        await _databaseServices.addUserDataToFirestore(username.text, email.text);
        await Prefs.setPrefUsername(username.text);
        await Prefs.setPrefEmail(email.text);
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
                        validator: (val) => (val!.isEmpty) ? "Please provide a valid username" : null,
                        controller: username,
                        style: textStyle(),
                        decoration: textFieldInputDecoration("Enter username"),
                      ),
                      SizedBox(height: 16.0),
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
                    performUserSignUp();
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
                          "Sign Up",
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
                      "Have an account?",
                      style: textStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Sign in now",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline
                          ),

                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
