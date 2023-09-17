

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Widgets/TrandingRecipeContainer.dart';

import '../../Global Models/Model.dart';
import '../../Global Styles/Listtile.dart';
import '../../Globle Controllers/controller.dart';
import '../../main.dart';
import '../Widgets/tabs.dart';

List<bool> isTab1Active = [true,false];
var tabs = ['Ingridents', 'Procedure',];
class Recipedetail extends StatefulWidget {
  var i,url;

   Recipedetail({this.i,this.url,super.key});

  @override
  State<Recipedetail> createState() => _RecipedetailState();
}

var savedItems = [];
class _RecipedetailState extends State<Recipedetail> {
  Map<String,dynamic>? items;
  var items2;
  var saved = [];

  Future<void> getdata() async {
    debugPrint("usama");
    final jsonString = prefs.getString('saved');
     saved = json.decode(jsonString);
      // saved.add(items2);
      debugPrint('saveddata is ${saved.length}');


  }
  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }
  int Selected = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<FoodDBProvider>(
          builder: (context, recipe, child)  {



            if(!recipe.ispcAdLoaded && !recipe.isiAdLoaded){
              recipe.initBannerAds_ingred();
              recipe.initBannerAds_procedue();
            }

          return WillPopScope(
            onWillPop: () async {

           recipe.setAllToNull();

              return true; // Return false if confirm is null (dialog dismissed)
            },
            child: Scaffold(
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(left:25.0,right: 25.0),
                  child: Container(
                    width: responsiveDesign(370, context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: responsive(20, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               InkWell(
                                   onTap: (){
                                     recipe.setAllToNull();
                                     Get.back();
                                   },
                                   child: Icon(Icons.arrow_back)),
                              //
                              // SvgPicture.asset(
                              //   'images/more.svg',
                              //   height: responsiveDesign(25/2, context)+ responsiveHeight(16/2, context),
                              //   width:  responsiveDesign(25/2, context)+ responsiveHeight(16/2, context),
                              // )
                            ],
                          ),
                        ),

                        Container(
                          height: responsive(200, context),
                          //width: responsive(350, context),
                          decoration: BoxDecoration(
                            // image: DecorationImage(
                            //   image:
                            //   ),

                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(responsive(15, context))),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) => SvgPicture.asset(
                                      width: responsive(410, context),

                                      'images/dummydish.svg',
                                    fit: BoxFit.fitWidth,
                                  ),

                                  imageUrl: '${widget.url}',
                                  width: responsive(410, context),
                                  // replace with the URL of your image
                                  fit: BoxFit.fitWidth,

                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(right: responsive(10, context),top:responsive(10, context) ),
                                    child: RecipeBadge(context, '4.5'),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(right: responsive(1, context),top:responsive(135, context) ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,

                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(left: responsive(10, context)),
                                          child: SvgPicture.asset(
                                            'images/timer.svg',
                                            height: responsiveDesign(16/2, context)+ responsiveHeight(16/2, context),
                                            width:  responsiveDesign(16/2, context)+ responsiveHeight(16/2, context),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                          child: normalText(
                                            color: Colors.white,
                                            context: context,
                                            text: '20 min'
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            saved.add(widget.i);
                                  recipe.saveToSharedPreferences(saved);
                                          },
                                          child: Padding(
                                            padding:  EdgeInsets.only(right: responsive(10, context),left: responsive(10, context)),
                                            child: CircleAvatar(
                                              radius: responsiveDesign(11/2, context)+ responsiveHeight(11/2, context),
                                              backgroundColor: Colors.white,
                                              child: SvgPicture.asset(
                                                'images/save.svg',
                                                height: responsiveDesign(16/2, context)+ responsiveHeight(16/2, context),
                                                width:  responsiveDesign(16/2, context)+ responsiveHeight(16/2, context),
                                              ),
                                            ),
                                          ),
                                        )


                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(

                              width: responsive(250, context),
                              child: HeadingText(
                                center: false,
                                text: '${widget.i.name}',
                                context: context,
                                color: Colors.black
                              ),
                            ),

                            // Padding(
                            //   padding:  EdgeInsets.fromLTRB(responsive(8, context), 0, 0, responsive(25, context)),
                            //   child: Container(
                            //     child: normalText(
                            //       color:Color.fromRGBO(169, 169, 169, 1),
                            //       context: context,
                            //       text: '(13K Reviews)'
                            //
                            //     ),
                            //   ),
                            // )

                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Container(
                            // height: 50,
                            // width: 380,
                            // color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: responsive(45, context),
                                  height: responsive(50, context),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxsR8Th9DhpNwI1Gsj2fyL8eHJgrY-kVEYWQ50040j&s"),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Color(0xFFFFCE80),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width:responsive(150,context),
                                        child: HeadingText(
                                          center: false,
                                          text: '${widget.i.author!}',
                                          context: context,
                                          color: Colors.black
                                        ),
                                      ),
                                      // Padding(
                                      //   padding:  EdgeInsets.fromLTRB(responsive(3, context), 0, responsive(50, context), 0),
                                      //   child: Row(
                                      //     children: [
                                      //       Icon(Icons.location_on,color: Colors.green,size: responsive(15, context),),
                                      //       smallText(
                                      //         color: Color.fromRGBO(169, 169, 169, 1),
                                      //         context: context,
                                      //         text: 'Lagos,Nigeria'
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),



                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: responsive(50, context),
                                ),

                                Container(
                                  height: responsive(40, context),
                                  width: responsive(80, context),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(18, 149, 117, 1),
                                    //Colors.pink,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: normalText(
                                      text: 'Follow',
                                      context: context,
                                      color: Colors.white
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: responsive(10, context),
                        ),

                        Padding(
                          padding:  EdgeInsets.only(left: responsive(10, context),right: 0 ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = 0; i < 2; i++)
                                InkWell(
                                  onTap: (){
                                    Selected = i;
                                    setState(() {

                                    });
                                  },

                                  child: StepsTabes(
                                    text: tabs[i],
                                    isSelected: i == Selected, // Set isSelected to true for the initially selected tab
                                  ),
                                ),
                            ],
                          ),

                        ),

                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: responsive(15, context),vertical: responsive(20, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child:Row(
                                  children: [
                                    SvgPicture.asset(
                                      'images/food.svg',
                                      height: responsive(16, context),
                                      width:  responsive(16, context)
                                    ),
                                    SizedBox(
                                      width:  responsive(5, context)
                                    ),
                                    smallText(
                                      color: Color.fromRGBO(169, 169, 169, 1),
                                      context: context,
                                      text: '1 serve'
                                    )
                                  ],
                                ),
                              ),
                              smallText(
                                  color: Color.fromRGBO(169, 169, 169, 1),
                                  context: context,
                                  text: '${ Selected == 1?widget.i.method!.length:widget.i.ingredients!.length} items'
                              )
                            ],
                          ),
                        ),

                     Selected == 1?   Padding(
                          padding:  EdgeInsets.symmetric(horizontal: responsive(10, context)),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              primary: true,
                              shrinkWrap: true,
                              itemCount: widget.i.method!.length,
                              itemBuilder: (context,i){

                                if ( recipe.ispcAdLoaded && i % 10 == 0) {
                                  // This is an ad slot position, show the banner ad here
                                  // Replace the AdWidget with the appropriate implementation for your banner ad
                                  return SizedBox(
                                    height:recipe.procedureBad[0].size.height.toDouble(),
                                    width: recipe.procedureBad[0].size.width.toDouble(),
                                    child: AdWidget(ad: recipe.procedureBad[i ~/ 5 ]),
                                  );
                                }

                                 else{
                                   return Padding(
                                       padding:  EdgeInsets.fromLTRB(0, responsive(5, context), 0, responsive(10, context)),
                                       child:  Container(
                                         width: responsive(315, context),
                                         decoration: ShapeDecoration(
                                           color: Color(0xffD9D9D9).withOpacity(0.3),
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(12),
                                           ),
                                         ),

                                         child: Padding(
                                           padding:  EdgeInsets.symmetric(horizontal: responsive(20, context),vertical: responsive(10, context)),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               MediumText(
                                                 center: false,
                                                 text: 'Step ${i+1}',
                                                 context: context,
                                               ),
                                               Padding(
                                                 padding:  EdgeInsets.symmetric(vertical: responsive(5, context)),
                                                 child: normalText(
                                                     center: false,
                                                     color:Color.fromRGBO(169, 169, 169, 1).withOpacity(0.6),
                                                     context: context,
                                                     text: '${widget.i.method![i]}'

                                                 ),
                                               ),

                                             ],
                                           ),
                                         ),
                                       )
                                   );
                                }


                              }),




                        ):
                        // List of INGRIDENTS
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: responsive(10, context)),
                          child:
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            primary: true,
                            shrinkWrap: true,
                            itemCount:recipe.isiAdLoaded ? widget.i.ingredients!.length + (widget.i.ingredients!.length ~/ 5): widget.i.ingredients!.length , // Adjusted item count to account for ads
                            itemBuilder: (context, i) {
                              if (recipe.isiAdLoaded && i % 6 == 0 && i != 0) {
                                // This is an ad slot position (every 6th position except the start), show the banner ad here
                                return SizedBox(
                                  height: recipe.ingrBad[0].size.height.toDouble(),
                                  width: recipe.ingrBad[0].size.width.toDouble(),
                                  child: AdWidget(ad: recipe.ingrBad[i ~/ 6]),
                                );
                              } else {
                                // This is a regular list item
                                int dataIndex = i - (i ~/ 6); // Calculate the adjusted dataIndex

                                if (recipe.isiAdLoaded && dataIndex >= 0 && dataIndex < widget.i.ingredients!.length) {
                                  debugPrint('now index is ${dataIndex}');
                                  // Ensure the dataIndex is within valid bounds
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: ListNew(
                                      context,
                                      '${widget.i.ingredients![dataIndex]}',
                                      '500g',
                                      'images/ingri.jpg',
                                    ),
                                  );
                                }else if(!recipe.isiAdLoaded){
                                  return  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: ListNew(
                                      context,
                                      '${widget.i.ingredients![i]}',
                                      '500g',
                                      'images/ingri.jpg',
                                    ),
                                  );
                            } else{
                                  // Return an empty container or another placeholder widget
                                  return Container();
                                }
                              }
                            },
                          )

                          // ListView.builder(
                          //   physics: NeverScrollableScrollPhysics(),
                          //     primary: true,
                          //   shrinkWrap: true,
                          //     itemCount: widget.i.ingredients!.length,
                          //     itemBuilder: (context,i){
                          //   return    Padding(
                          //       padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          //       child:
                          //       ListNew(context, '${widget.i.ingredients![i]}', '500g', 'images/ingri.jpg')
                          //   );
                          // }),
                        ),





                      ],
                    ),
                  ),
                ),
              ),

            ),
          );
        }
      ),
    );
  }
}