
import 'package:beats_music/colors/colors.dart';
import 'package:flutter/material.dart';

const bold = "bold";
const regular = "regular";

OurStyle({ family = "regular",double? size = 14, color = whiteColor}){
  return  TextStyle(
      fontSize: 18,
      color: color,
      fontFamily: family,
  );
}