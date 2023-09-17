import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipeapp/Global%20Styles/AppFonts.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

import '../../Global Models/Model.dart';

Widget Search(BuildContext context, var onchange, onchan) {
  return Container(
    width: responsiveDesign(350, context),
    height: responsive(50, context),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            width: responsive(0.65, context), color: Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Center(
      child: TextField(
        onChanged: onchan,
        onSubmitted: onchange,
        style: TextStyle(
          // color: Colors.black45.withOpacity(0.4),
          // fontSize: responsiveDesign(11, context),
          fontFamily: AppFonts.poppinsMedium,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.black45.withOpacity(0.4),
            fontSize: responsive(14, context),
            fontFamily: AppFonts.poppinsMedium,
            fontWeight: FontWeight.w400,
          ),
          hintText: 'Search recipe',
          prefixIconConstraints: BoxConstraints(
            minHeight: responsive(25, context),
            minWidth: responsive(25, context),
            maxHeight: responsive(100, context),
            maxWidth: responsive(100, context),
          ),
          prefix: SizedBox(
            width: responsive(6, context),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: responsive(10, context)),
            child: SvgPicture.asset(
              'images/search.svg',
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    ),
  );
}
