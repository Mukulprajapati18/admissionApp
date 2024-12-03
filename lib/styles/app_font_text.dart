import 'package:flutter/material.dart';

class AppFontText{

  Widget displayMediumText(String text, Color color, {TextAlign? textAlign}){
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w400,),
    );
  }

  Widget headingMediumText(String text, Color color, {TextAlign? textAlign, TextDecoration? textDecoration, TextOverflow? textOverflow, int? maxLines}){
    return Text(
      text,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700, decoration: textDecoration),
    );
  }

  Widget paragraphMediumText(String text, Color color, {TextAlign? textAlign, TextDecoration? textDecoration, int? maxLine, TextOverflow? textOverflow}){
    return Text(
      text,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(color: color, fontSize: 14,fontWeight: FontWeight.w500, decoration: textDecoration),
    );
  }

  Widget paragraphSmallText(String text, Color color, {TextAlign? textAlign, TextDecoration? textDecoration, int? maxLines, TextOverflow? overflow}){
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500, decoration: textDecoration),
    );
  }

  Widget labelMediumText(String text, Color color, {TextAlign? textAlign, TextOverflow? overFlow, TextDecoration? textDecoration, int? maxLines}){
    return Text(
      text,
      overflow: overFlow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(color: color, fontSize: 14,fontWeight: FontWeight.w700, decoration: textDecoration),
    );
  }
}