
import 'package:flutter/material.dart';
import 'package:recipeapp/Global%20Styles/AppFonts.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

Widget  MediumlargeText({var center, text,context,Color? color}){
  return Text(
    '$text',
    textAlign: center == null? TextAlign.center:center!=null&&center == false?TextAlign.left:TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: responsiveDesign(18/2, context)+ responsiveHeight(18/2, context),
      fontFamily: AppFonts.poppinsMedium,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget  HeadingText({var center, text,context,Color? color}){
  return Text(
    '$text',
    textAlign: center == null? TextAlign.center:center!=null&&center == false?TextAlign.left:TextAlign.center,

    style: TextStyle(
      color: color,
      fontSize: responsiveDesign(20/2, context)+ responsiveHeight(20/2, context),
      fontFamily: AppFonts.poppinsSemiBold,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget  MediumText({var center, text,context,Color? color}){
  return Text(
    '$text',
    textAlign: center == null? TextAlign.center:center!=null&&center == false?TextAlign.left:TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: responsiveDesign(16/2, context)+ responsiveHeight(16/2, context),
      fontFamily: AppFonts.poppinsMedium,
      fontWeight: FontWeight.bold,
    ),
  );
}
Widget  ExtraLargeText({var center, text,context,Color? color}){
  return Text(
    '$text',
    textAlign: center == null? TextAlign.center:center!=null&&center == false?TextAlign.left:TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: responsiveDesign(50/2, context)+ responsiveHeight(50/2, context),
      fontFamily: AppFonts.poppinsMedium,
      fontWeight: FontWeight.w600,
     //  height: responsiveHeight(60, context),
    ),
  );
}
Widget  normalText({var center, text,context,Color? color}){
  return Text(
    '$text',
    textAlign: center == null? TextAlign.center:center!=null&&center == false?TextAlign.left:TextAlign.center,
    // overflow: TextOverflow.ellipsis,
    style: TextStyle(

      color: color,
      fontSize: responsiveDesign(14/2, context)+ responsiveHeight(14/2, context),
      fontFamily: AppFonts.poppinsSemiBold,
      fontWeight: FontWeight.w600,
      //  height: responsiveHeight(60, context),
    ),
  );
}

Widget  smallText({var center, text,context,Color? color}){
  return Text(
    '$text',
    textAlign: center == null? TextAlign.center:center!=null&&center == false?TextAlign.left:TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: responsive(11, context),
      fontFamily: AppFonts.poppinsMedium,
      fontWeight: FontWeight.w600,
      //  height: responsiveHeight(60, context),
    ),
  );
}