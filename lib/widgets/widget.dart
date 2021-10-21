import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54))
  );
}

TextStyle textStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 16.0
  );
}


Widget loadingScreen() {
  return Container(
    color: Colors.black12,
    child: SpinKitCircle(
      color: Colors.red,
      size: 75.0,
    ),
  );
}
