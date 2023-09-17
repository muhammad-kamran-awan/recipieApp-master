import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/View/Profile/forgetpassword.dart';
import 'package:recipeapp/View/Widgets/CustomAddTextField.dart';
import 'package:recipeapp/View/authentication/firebase_auth.dart';

import '../../Responsive/Responsiveclass.dart';
import '../Home/View/Home.dart';
import 'Signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email, password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(responsive(30, context),
            responsive(100, context), responsive(30, context), 0),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingText(
                      center: true,
                      context: context,
                      text: 'Hello,',
                      color: Colors.black),
                  MediumlargeText(
                      context: context,
                      center: true,
                      text: 'Welcome Back!',
                      color: Colors.black),
                  SizedBox(
                    height: responsive(80, context),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        responsive(5, context), 0, 0, responsive(5, context)),
                    child: MediumlargeText(
                        color: Colors.black,
                        center: true,
                        text: "Email",
                        context: context),
                  ),
                  MyCustomTextField(
                    obsecure: false,
                    width: responsive(400, context),
                    height: responsive(60, context),
                    hintText: 'Enter Email',
                    onchange: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: responsive(30, context),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        responsive(5, context), 0, 0, responsive(5, context)),
                    child: MediumlargeText(
                        color: Colors.black,
                        center: true,
                        text: "Enter Password",
                        context: context),
                  ),
                  MyCustomTextField(
                    obsecure: true,
                    width: responsive(400, context),
                    height: responsive(60, context),
                    hintText: 'Enter Password',
                    onchange: (value) {
                      password = value;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(responsive(5, context),
                        responsive(20, context), 0, responsive(5, context)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen()),
                        );
                      },
                      child: normalText(
                          text: 'Forgot Password',
                          center: false,
                          context: context,
                          color: Color(0xFFFF9B00).withOpacity(0.7)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(responsive(0, context),
                        responsive(80, context), 0, responsive(0, context)),
                    child: InkWell(
                      onTap: () async {
                        isLoading = true;
                        setState(() {});
                        await FirebaseServices.login(email, password)
                            .then((value) async {
                          await Get.to(MainPage());
                        });
                      },
                      child: Container(
                        width: responsive(400, context),
                        height: responsive(60, context),
                        // padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 18),
                        decoration: ShapeDecoration(
                          color: Color(0xFF119475),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
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
                              : Container(
                                  child: normalText(
                                      center: true,
                                      color: Colors.white,
                                      context: context,
                                      text: "Sign In"),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(responsive(0, context),
                        responsive(20, context), 0, responsive(0, context)),
                    child: InkWell(
                      onTap: () {
                        Get.to(Signup());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          normalText(
                              text: 'Don’t have an account?',
                              context: context,
                              center: true,
                              color: Colors.black),
                          normalText(
                              text: 'Sign up ',
                              context: context,
                              center: true,
                              color: Color(0xFFFF9B00).withOpacity(0.7))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
