
import 'package:flutter/material.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;

  CustomButton({
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
      onTap: onTap,
      child: Container(
        width: responsive(192, context),
        height: responsive(55, context),
        // padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 18),
        decoration: ShapeDecoration(
          color: Color(0xFF119475),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Container(
            child: normalText(
              center: true,
              color: Colors.white,
              context: context,
              text: "$text"
            ),
          ),
        ),
      ),
    );
  }
}