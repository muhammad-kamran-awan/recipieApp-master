

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipeapp/View/Widgets/NotificationWidget.dart';

import '../../Global Styles/TextFiles.dart';
import '../../Responsive/Responsiveclass.dart';
import '../Widgets/tabs.dart';
List tabs = ['All','Unread','Read'];

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var Selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: responsive(15, context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                      HeadingText(
                          text: 'Notifications',
                          context: context,
                          center: false
                      ),


                    ],
                  ),
                ),
      Padding(
          padding:  EdgeInsets.symmetric(horizontal: responsive(15, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 3; i++)
                InkWell(
                  onTap: (){
                    Selected = i;
                    setState(() {

                    });
                  },

                  child: StepsTabes(
                    width: 107,
                    text: tabs[i],
                    isSelected: i == Selected, // Set isSelected to true for the initially selected tab
                  ),
                ),
            ],)),
                SizedBox(height: responsive(10, context),),
                MediumText(
                  text: 'Today',
                  context: context,
                  center: true,
                ),
                SizedBox(height: responsive(10, context),),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    primary: true,
                    shrinkWrap: true,
                    itemBuilder: (context,i){
                  return NotiWidget();
                })


              ],
            ),
          ),
        ),
      ) ,
    );
  }
}
