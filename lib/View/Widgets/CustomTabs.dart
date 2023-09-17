import 'package:flutter/material.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CustomTab({
    Key? key,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: responsive(5, context)),
      child: Container(
      //  width: responsiveDesign(57, context),
        height: responsive(40, context),
      padding:  EdgeInsets.symmetric(horizontal: responsive(20, context), vertical: responsive(7, context)),
        decoration: ShapeDecoration(
          color: isSelected ? Color(0xFF119475) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive(10, context)),
          ),
        ),
        child: Center(
          child: smallText(
            text: text,
            color: isSelected ? Colors.white : Color(0xFF119475),
            context: context,
          ),
        )

      ),
    );
  }
}