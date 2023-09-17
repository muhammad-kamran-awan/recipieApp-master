import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Global Styles/Buttons.dart';
import '../../Global Styles/TextFiles.dart';
import '../../Responsive/Responsiveclass.dart';
import '../Home/View/Home.dart';
import '../authentication/Login.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: responsiveHeight(70, context)),
            child: Column(
              children: [
                Image.asset(
                  'images/slogo.png',
                  height: responsiveHeight(79, context),
                  width: responsiveDesign(79, context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: responsiveHeight(20, context)),
                  child: MediumlargeText(
                      text: '100K+ Premium Recipe ',
                      context: context,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(top: responsiveHeight(180, context)),
                  child: ExtraLargeText(
                      text: 'Get\nCooking',
                      context: context,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: responsiveHeight(20, context)),
                  child: MediumText(
                      text: 'Simple way to find Tasty Recipe',
                      context: context,
                      color: Colors.white),
                ),
                InkWell(
                  onTap: () {
                    isLoading = true;
                    setState(() {});

                    // isLoading=false;
                    Get.offAll(MainPage());
                    // Get.to(Login());
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: responsiveHeight(120, context)),
                    child: isLoading == true
                        ? Container(
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
                                height: responsive(20, context),
                                width: responsive(20, context),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 0.9,
                                ),
                              ),
                            ),
                          )
                        : normalButton(
                            context,
                            "Start Cooking",
                            Colors.white,
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
