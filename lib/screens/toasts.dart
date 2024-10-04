


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showAlaram() {

  Fluttertoast.showToast(
    msg: "Sleep timer has expired.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
  );
}


showDefault(){

  Fluttertoast.showToast(
    msg: "We are working on this, will be soon available",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

showDefault1(){

  Fluttertoast.showToast(msg:" This Feature is not available now",
      //textColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
  timeInSecForIosWeb: 3,
  backgroundColor: Colors.redAccent,
  textColor: Colors.white,
  fontSize: 18,);
}