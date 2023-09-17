import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Global Styles/TextFiles.dart';
import '../../Responsive/Responsiveclass.dart';

class NotiWidget extends StatelessWidget {
  const NotiWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:  EdgeInsets.fromLTRB(responsive(20, context), responsive(15, context), responsive(20, context), responsive(10, context)),
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
            child: Container(
              width: responsive(315, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      MediumText(
                        center: false,
                        text: 'New Recipe Alert!',
                        context: context,
                      ),
                      SvgPicture.asset(
                          'images/unread.svg',
                          height: responsive(28, context),
                          width:  responsive(28, context)
                      ),
                    ],

                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: responsive(5, context)),
                    child: normalText(
                        center: false,
                        color:Color.fromRGBO(169, 169, 169, 1).withOpacity(0.6),
                        context: context,
                        text: 'Lorem Ipsum tempor incididunt ut labore et dolore,in voluptate velit esse cillum dolore eu fugiat nulla pariatur?'

                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

    );
  }
}
