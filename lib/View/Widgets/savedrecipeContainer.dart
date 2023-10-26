import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Widgets/searchResultWidget.dart';

class savedRecipeContainer extends StatelessWidget {
  var url, name, time;
  savedRecipeContainer(
      {required this.name, required this.time, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, bottom: 10, right: 15, left: 15),
      child: Container(
        height: 200,
        width: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CachedNetworkImage(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  errorWidget: (context, url, error) =>
                      SvgPicture.asset('images/dummydish.svg'),
                  imageUrl: '$url',
                  // replace with the URL of your image
                  fit: BoxFit.fill),
              Positioned(
                  top: responsiveDesign(10 / 2, context) +
                      responsiveHeight(10 / 2, context),
                  right: responsiveDesign(10 / 2, context) +
                      responsiveHeight(10 / 2, context),
                  child: RecipeBadge(context, '4.5')),
              Positioned(
                bottom: responsiveDesign(25 / 2, context) +
                    responsiveHeight(25 / 2, context),
                left: responsiveDesign(10 / 2, context) +
                    responsiveHeight(10 / 2, context),
                child: Container(
                  // height: responsive(45, context),
                  // width: responsive(170, context),
                  child: HeadingText(
                    center: true,
                    text: '$name',
                    context: context,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                  bottom: responsiveDesign(20 / 2, context) +
                      responsiveHeight(20 / 2, context),
                  right: responsiveDesign(0 / 2, context) +
                      responsiveHeight(0 / 2, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: normalText(
                          text: time.toString() + " min ",
                          context: context,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: responsiveDesign(10, context)),
                        child: CircleAvatar(
                          radius: responsiveDesign(11 / 2, context) +
                              responsiveHeight(11 / 2, context),
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset(
                            'images/save.svg',
                            height: responsiveDesign(16 / 2, context) +
                                responsiveHeight(16 / 2, context),
                            width: responsiveDesign(16 / 2, context) +
                                responsiveHeight(16 / 2, context),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
