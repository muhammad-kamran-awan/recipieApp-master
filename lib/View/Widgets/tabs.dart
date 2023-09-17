import 'package:flutter/material.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

import '../../Global Styles/TextFiles.dart';

class StepsTabes extends StatelessWidget {
  final String text;
  final bool isSelected;
  var height,width;

   StepsTabes({
    Key? key,
    this.width,
    this.height,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: responsive(5, context)),
      child: Container(
          height: responsive(height??40, context),
          width: responsive(width ?? 170, context),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: ShapeDecoration(
            color: isSelected ? Color(0xFF119475) : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child: normalText(
              text: text,
              color: isSelected ? Colors.white : Color(0xFF119475),
              context: context,
            ),
          )

      ),
    );
  }
}