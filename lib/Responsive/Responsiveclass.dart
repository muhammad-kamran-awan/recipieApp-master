import 'package:flutter/cupertino.dart';

// String getDate(String date){
//   return (DateFormat("MMMM-dd-yyyy hh:mm").format( DateTime.parse(date).toLocal())).toString();
// }




double responsiveDesign (double pixel, var context){
    return MediaQuery.of(context).size.width *  (pixel / 398);
  }
double responsiveHeight (double pixel, var context){
    return MediaQuery.of(context).size.height *  (pixel / 926);
  }

  double responsive (pixel, context){
  return responsiveDesign(pixel/2, context)+ responsiveHeight(pixel/2, context);
  }