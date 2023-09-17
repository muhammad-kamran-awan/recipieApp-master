import 'package:flutter/material.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

import '../../Global Styles/TextFiles.dart';

class NewStepsTabes extends StatelessWidget {
  final String text;
  final bool isSelected;

  const NewStepsTabes({
    Key? key,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: responsive(5, context)),
      child: Container(
          height: responsive(40, context),
          width: responsive(107, context),
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