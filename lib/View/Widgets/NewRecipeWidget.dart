import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';

class NewRecipe extends StatelessWidget {
  var url, name, autherImage, auther, cookingTime;

  NewRecipe(
      {required this.name,
      required this.url,
      required this.cookingTime,
      required this.auther,
      required this.autherImage,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsive(170, context),
      width: responsive(295, context),
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive(20, context)),
              ),
              color: Colors.grey[200],
              child: Container(
                height: responsive(150, context),
                width: responsive(300, context),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: responsive(10, context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: responsive(150, context),
                                height: responsive(20, context),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      responsive(10, context), 0, 0, 0),
                                  child: normalText(
                                    center: false,
                                    text: '$name',
                                    context: context,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: responsive(10, context),
                                    top: responsive(5, context),
                                    bottom: responsive(5, context)),
                                child: Container(
                                  height: responsive(20, context),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 5,
                                      itemBuilder: (context, i) {
                                        return Icon(
                                          Icons.star,
                                          color: Color(0xffFFAD30),
                                          size: responsive(15, context),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: responsive(20, context)),
                              child: CircleAvatar(
                                backgroundColor: Color(0xFFD9D9D9),
                                radius: responsive(40, context),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        SvgPicture.asset(
                                            width: 100,
                                            height: 100,
                                            'images/dummydish.svg'),
                                    imageUrl: '$url',
                                    // replace with the URL of your image
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: responsive(10, context)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFFD9D9D9),
                                  radius: responsive(15, context),
                                  backgroundImage: NetworkImage(autherImage),
                                ),
                                SizedBox(
                                  width: responsive(5, context),
                                ),
                                smallText(
                                  text: 'By $auther',
                                  context: context,
                                  color: Color(0xFFA9A9A9),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Time"),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: responsive(10, context)),
                                  child: Row(children: [
                                    Icon(
                                      Icons.watch_later_outlined,
                                      size: responsive(17, context),
                                      color: Color(0xFFA9A9A9),
                                    ),
                                    SizedBox(
                                      width: responsive(5, context),
                                    ),
                                    smallText(
                                      text: cookingTime,
                                      context: context,
                                      color: Color(0xFFA9A9A9),
                                    ),
                                    smallText(
                                      text: " Mins",
                                      context: context,
                                      color: Color(0xFFA9A9A9),
                                    ),
                                  ]),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
