import 'package:flutter/material.dart';

import '../Responsive/Responsiveclass.dart';
import 'TextFiles.dart';



Widget ListNew(context,TITLEtext,trailingtext,imagePath){
  return
    Container(
      width: responsive(315, context),
      height: responsive(76, context),
      decoration: BoxDecoration(
        color: Color(0xffD9D9D9).withOpacity(0.3),
        borderRadius: BorderRadius.circular(responsive(10, context)),
      ),
      child: Center(
        child: ListTile(
        
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        leading: Container(
          width: responsive(45, context),
          height: responsive(45, context),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Padding(
            padding:  EdgeInsets.all(responsive(5, context)),
            child: Image.asset('$imagePath'),
          ),
        ),

        title: normalText(
          center: false,
            context: context,
            text: '$TITLEtext',
            color: Colors.black
        ),
        // trailing: normalText(
        //   context: context,
        //   text: '$trailingtext',
        //   color: Color.fromRGBO(169, 169, 169, 1),
        // ),

  ),
      ),
    );
}