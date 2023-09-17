import 'package:flutter/material.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

class CurvedNavigationBar extends StatelessWidget {
  final List<Widget> items;
  final Function(int) onTap;
  final Color backgroundColor;
  final int selectedIndex;

  CurvedNavigationBar({
    required this.items,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: backgroundColor,
      child: Container(
        height: responsive(70, context),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.asMap().entries.map((entry) {
            final int index = entry.key;
            final Widget item = entry.value;

            return GestureDetector(
              onTap: () => onTap(index),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding:  EdgeInsets.only(
                      left:index==1?responsiveDesign(25, context): responsiveDesign(35, context),right: index==1?responsiveDesign(61, context):index==2?responsiveDesign(25, context):responsiveDesign(35, context),
                      ),
                  child: item,
                ),  
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}