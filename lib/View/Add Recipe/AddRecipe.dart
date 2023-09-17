import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/View/Home/View/Home.dart';

import '../../Globle Controllers/controller.dart';
import '../../Globle Controllers/userdataclass.dart';
import '../../Responsive/Responsiveclass.dart';
import '../Widgets/CustomAddTextField.dart';
import '../Widgets/CustomButton.dart';

class Addrecipe extends StatefulWidget {
  const Addrecipe({super.key});

  @override
  State<Addrecipe> createState() => _AddrecipeState();
}

class _AddrecipeState extends State<Addrecipe> {
  var name,auther,time;
  List<Widget> ingredients = [];
  List<Widget> procedures = [];
  bool isLoading = false;

  List<String> ingredientsvalues = [];
  List<String> proceduressvalues = [];

  Future<void> uploadDataToFirestore(Map<String, dynamic> data) async{
    await FirebaseFirestore.instance.collection('Recipes').add(data);

  }




  File? _imageFile;
  var imgpath,pickedImage;
  String _uploadedImageUrl='';
  var downloadUrl;
  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
     pickedImage = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality:40);

    if (pickedImage != null) {
      setState(() {
        imgpath= pickedImage.path;
        _imageFile = File(pickedImage.path);
        // _uploadImage();
      });
    }
  }

  // Function to upload profile image to storage and save image URL to Firestore
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      // Step 1: Upload the image to Firebase Storage
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child('Recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});

      // Step 2: Get the uploaded image's URL
      if (snapshot.state == TaskState.success) {
        downloadUrl = await storageRef.getDownloadURL();


          setState(() {

          });



          Fluttertoast.showToast(msg: "PIC Uploaded :) ");

        }
      }
    catch (error) {
      print("Error uploading image: $error");
    }
  }





  @override
  Widget build(BuildContext context) {
    print('path is ${imgpath}');
    return Scaffold(
        body: SafeArea(
            child: Consumer2<FoodDBProvider,UserDataController>(
                builder: (context, recipe,user, child) {
                return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Consumer<FoodDBProvider>(
                  builder: (context, recipe, child) {

                    if(recipe.dataa.isEmpty){

                    }
                  return Container(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              responsive(15, context), 0, responsive(15, context), 0),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsive(20, context)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Icon(Icons.arrow_back)),
                                      HeadingText(
                                          center: true,
                                          context: context,
                                          text: 'Add Recipe',
                                          color: Colors.black),
                                      SizedBox(
                                        width: responsive(40, context),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            MyCustomTextField(
                                              height: responsive(55, context),
                                              width: responsive(200, context),
                                              hintText: 'Name',
                                              onchange: (value){
                                                name=value;
                                              },
                                              obsecure: false,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, responsive(10, context), 0, 0),
                                              child: MyCustomTextField(
                                                  height: responsive(55, context),
                                                  width: responsive(200, context),
                                                  hintText: 'Time Taken',
                                                onchange: (value){
                                                    time = value;
                                                },
                                                obsecure: false,

                                              ),
                                            )
                                          ],
                                        ),
                                       imgpath==null? SvgPicture.asset(
                                          'images/ImageUpload.svg',
                                          height: responsive(100, context),
                                        ):Container(
                                         height: responsive(110, context),
                                         width: responsive(192, context),
                                         decoration: BoxDecoration(
                                           image: DecorationImage(
                                             image: FileImage(File(imgpath)),
                                             fit: BoxFit.fitWidth,
                                           ),
                                           borderRadius: BorderRadius.circular(10),
                                         ),
                                       ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0, responsive(10, context), 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyCustomTextField(
                                            height: responsive(55, context),
                                            width: responsive(200, context),
                                            hintText: ' chef name ',
                                            onchange: (value){
                                              auther = value;

                                            },
                                            obsecure: false,
                                          ),
                                          CustomButton(
                                            text: 'Pick Image',
                                            onTap: () {
                                              _pickImage();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      primary: true,
                                      itemCount: ingredients.length,
                                      itemBuilder: (context, index) {
                                        print(
                                          ingredientsvalues.length - 1 == index
                                              ? ingredientsvalues[index]
                                              : "",
                                        );
                                        final item = ingredients[index];

                                        return
                                          Padding(
                                            padding:  EdgeInsets.only(top: responsive(10, context)),
                                            child: SwipeActionCell(

                                            key: ObjectKey(item),

                                            /// this key is necessary
                                            trailingActions: <SwipeAction>[
                                              SwipeAction(
                                                  performsFirstActionWithFullSwipe: true,

                                                  icon: Icon(Icons.delete,color: Colors.white,size: responsive(30, context),),
                                                  backgroundRadius: 10.0,
                                                  // title: "delete",
                                                  onTap:
                                                      (CompletionHandler handler) async {
                                                    print(ingredientsvalues);

                                                    ingredients.remove(item);
                                                    if (ingredientsvalues.length - 1 <
                                                        index) {
                                                    } else {
                                                      final ingri =
                                                          ingredientsvalues[index];
                                                      ingredientsvalues.remove(ingri);
                                                    }

                                                    setState(() {});
                                                  },
                                                  color: Colors.red),
                                            ],
                                            child:
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, responsive(0, context), 0, 0),
                                              child: MyCustomTextField(
                                                obsecure: false,
                                                onchange: (value) {
                                                  try{
                                                    ingredientsvalues[index]=value;
                                                  } catch(e){
                                                    print(e);
                                                    ingredientsvalues.add(value);
                                                  }

                                                  print(index);
                                                  print(ingredientsvalues.length - 1);
                                                },
                                                text: ingredientsvalues.length - 1 < index
                                                    ? ""
                                                    : ingredientsvalues.isEmpty
                                                        ? ""
                                                        : ingredientsvalues[index],
                                                height: responsive(55, context),
                                                width: responsive(420, context),
                                                hintText: 'Ingredient ${index + 1}',
                                              ),
                                            ),
                                        ),
                                          );
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0, responsive(10, context), 0, 0),
                                      child: Row(
                                        mainAxisAlignment: procedures.isEmpty
                                            ? MainAxisAlignment.spaceBetween
                                            : MainAxisAlignment.end,
                                        children: [
                                          procedures.isEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    procedures.add(
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(
                                                            0,
                                                            responsive(10, context),
                                                            0,
                                                            0),
                                                        child: MyCustomTextField(
                                                          obsecure: false,
                                                          height:
                                                              responsive(55, context),
                                                          width:
                                                              responsive(400, context),
                                                          hintText: 'Procedure  ',
                                                        ),
                                                      ),
                                                    );
                                                    setState(() {});
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            responsive(20, context)),
                                                    child: SvgPicture.asset(
                                                      'images/addprocedure.svg',
                                                      height: responsive(18, context),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          InkWell(
                                            onTap: () {
                                              ingredients.add(
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, responsive(10, context), 0, 0),
                                                  child: MyCustomTextField(
                                                    obsecure: false,
                                                    height: responsive(55, context),
                                                    width: responsive(400, context),
                                                    hintText: 'Ingredients  ',
                                                  ),
                                                ),
                                              );
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: responsive(25, context)),
                                              child: SvgPicture.asset(
                                                'images/Addingredients.svg',
                                                height: responsive(18, context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      primary: true,
                                      itemCount: procedures.length,
                                      itemBuilder: (context, index) {
                                        final items = procedures[index];

                                        return
                                          Padding(
                                            padding:  EdgeInsets.only(top: responsive(10, context)),
                                            child: SwipeActionCell(
                                              key: ObjectKey(items),
                                              /// this key is necessary
                                              trailingActions: <SwipeAction>[
                                                SwipeAction(
                                                    performsFirstActionWithFullSwipe: true,
                                                  icon: Icon(Icons.delete,color: Colors.white,size: responsive(30, context),),
                                                  backgroundRadius: 10.0,
                                                  //   title: "delete",
                                                    onTap:
                                                        (CompletionHandler handler) async {
                                                      print(proceduressvalues);

                                                      procedures.remove(items);
                                                      if (proceduressvalues.length - 1 <
                                                          index) {
                                                      } else {
                                                        final proce =
                                                        proceduressvalues[index];
                                                        proceduressvalues.remove(proce);
                                                      }

                                                      setState(() {});
                                                    },
                                                    color: Colors.red),
                                              ],
                                              child:
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, responsive(0, context), 0, 0),
                                                child: MyCustomTextField(
                                                  obsecure: false,
                                                  onchange: (value) {

                                                      try{
                                                        proceduressvalues[index]=value;
                                                      } catch(e){
                                                        print(e);
                                                        proceduressvalues.add(value);
                                                      }



                                                    // proceduressvalues[index].isEmpty?proceduressvalues.add(value):proceduressvalues[index] = value;
                                                    print(index);
                                                    print(proceduressvalues.length - 1);
                                                  },
                                                  text: proceduressvalues.length - 1 < index
                                                      ? ""
                                                      : proceduressvalues.isEmpty
                                                      ? ""
                                                      : proceduressvalues[index],
                                                  height: responsive(55, context),
                                                  width: responsive(420, context),
                                                  hintText: 'Step ${index + 1}',
                                                ),
                                              ),
                                            ),
                                          );
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: responsive(150, context)),
                                      child: Visibility(
                                        visible: procedures.isEmpty ? false : true,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, responsive(10, context), 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  procedures.add(
                                                    Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          0,
                                                          responsive(10, context),
                                                          0,
                                                          0),
                                                      child: MyCustomTextField(
                                                        obsecure: false,
                                                        height: responsive(55, context),
                                                        width: responsive(400, context),
                                                        hintText: 'Procedure  ',
                                                      ),
                                                    ),
                                                  );
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          responsive(20, context)),
                                                  child: SvgPicture.asset(
                                                    'images/addprocedure.svg',
                                                    height: responsive(18, context),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )));
                }
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
                padding: EdgeInsets.only(
                    bottom: responsive(20, context), top: responsive(40, context)),
                child: isLoading == true?Container(
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
                ): CustomButton(

                  text: 'Submit',
                  onTap: () async {
                    isLoading = true;
                    setState(() {

                    });
                    await _uploadImage();
                   await  uploadDataToFirestore({
                      "Name": "$name",
                      "email": FirebaseAuth.instance.currentUser!.email,
                      "url": "$downloadUrl",
                      "timetaken": "$time",
                      "Description": "Combine a few key Christmas flavours here to make a pie that both children and adults will adore",
                      "Author": "$auther",
                      "Ingredients": ingredientsvalues,
                      "Method": proceduressvalues,
                     "time":DateTime.now().toString(),
                    });

                    await recipe.fetchDataFromFirestore();
                   await  user.fetchCurrentUSerPostFromFirestore();
                    isLoading = false;
                    setState(() {

                    });
                    Get.back();
                  },
                ),
          ),
        )
      ],
    );
              }
            )));
  }
}
