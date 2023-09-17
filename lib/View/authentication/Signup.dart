import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeapp/View/authentication/firebase_auth.dart';

import '../../Global Styles/TextFiles.dart';
import '../../Responsive/Responsiveclass.dart';
import '../Widgets/CustomAddTextField.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isChecked = false;
  var name, email, password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(responsive(30, context),
            responsive(50, context), responsive(30, context), 0),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(
                        center: true,
                        context: context,
                        text: 'Create an account,',
                        color: Colors.black),
                    MediumlargeText(
                        context: context,
                        center: false,
                        text:
                            'Let’s help you set up your account,\nit won’t take long.',
                        color: Colors.black),
                    SizedBox(
                      height: responsive(40, context),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          responsive(5, context), 0, 0, responsive(5, context)),
                      child: MediumlargeText(
                          color: Colors.black,
                          center: true,
                          text: "Name",
                          context: context),
                    ),
                    MyCustomTextField(
                      obsecure: false,
                      width: responsive(400, context),
                      height: responsive(60, context),
                      hintText: 'Enter Name',
                      onchange: (value) {
                        name = value;
                      },
                      validator: (input) {
                        if (input.isEmpty) {
                          setState(() {});
                          return 'Please type something';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsive(20, context),
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
                      validator: (input) {
                        if (input.contains('@gmail.com')) {
                          return null;
                        } else {
                          setState(() {});
                          return 'Please write valid email';
                        }
                      },
                    ),
                    SizedBox(
                      height: responsive(20, context),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          responsive(5, context), 0, 0, responsive(5, context)),
                      child: MediumlargeText(
                        color: Colors.black,
                        center: true,
                        text: "Password",
                        context: context,
                      ),
                    ),
                    MyCustomTextField(
                      obsecure: true,
                      width: responsive(400, context),
                      height: responsive(60, context),
                      hintText: 'Enter Password',
                      onchange: (value) {
                        password = value;
                      },
                      validator: (input) {
                        if (input.isEmpty) {
                          setState(() {});
                          return 'Enter valid password ';
                        } else
                          return null;
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                          // shape: CircleBorder(),
                          activeColor: Color(0xFFFF9B00).withOpacity(0.7),
                          checkColor: Colors.black,
                          value: _isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              _isChecked = newValue!;
                            });
                          },
                        ),

                        // Text('Checkbox is ${_isChecked ? 'checked' : 'unchecked'}'),

                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              responsive(0, context),
                              responsive(0, context),
                              0,
                              responsive(0, context)),
                          child: InkWell(
                            onTap: () {},
                            child: normalText(
                                text:
                                    "terms & Condition ${_isChecked ? 'Accepted' : '?'}",
                                center: false,
                                context: context,
                                color: Color(0xFFFF9B00).withOpacity(0.7)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(responsive(0, context),
                          responsive(80, context), 0, responsive(0, context)),
                      child: InkWell(
                        onTap: () async {
                          final formState = formKey.currentState;
                          if (formState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            formState!.save();
                            await FirebaseServices.signUp(
                                name, email, password);
                            Get.back();
                            // then do something
                          }
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
                                        text: "Sign UP"),
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
                          Get.back();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            normalText(
                                text: 'Already a member?',
                                context: context,
                                center: true,
                                color: Colors.black),
                            normalText(
                                text: ' Sign In',
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
      ),
    );
  }
}
