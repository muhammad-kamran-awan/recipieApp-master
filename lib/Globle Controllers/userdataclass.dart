

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../Global Models/Model.dart';
import '../Global Models/UserModel.dart';

class UserDataController extends ChangeNotifier{
  UserModel? UserData;
  List<recipesDB> UserPostData = [];
  File? _imageFile;
  var isLoading = false;
  String _uploadedImageUrl='';

  // Function to pick an image from gallery
  Future<void> pickImage() async {

    notifyListeners();
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality:40);

    if (pickedImage != null) {

        _imageFile = File(pickedImage.path);
        _uploadImage();

    }
  }

  // Function to upload profile image to storage and save image URL to Firestore
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    isLoading = true;
    try {
      // Step 1: Upload the image to Firebase Storage
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});

      // Step 2: Get the uploaded image's URL
      if (snapshot.state == TaskState.success) {
        final downloadUrl = await storageRef.getDownloadURL();

        // Step 3: Save the image URL to Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userCollectionRef = FirebaseFirestore.instance.collection('Users');
          final currentUserDocRef = userCollectionRef.doc(user.uid);

          await currentUserDocRef.update({
            'profileimageurl': downloadUrl,
          });


            _uploadedImageUrl = downloadUrl;
          await fetchDataFromFirestore();
          isLoading = false;
          notifyListeners();
          Fluttertoast.showToast(msg: "PIC Uploaded :) ");

        }
      }
    } catch (error) {
      print("Error uploading image: $error");
    }
  }


  Future<void> fetchDataFromFirestore() async {


    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
      querySnapshot.docs.reversed.forEach((document) async {
        // print("data = ${document.data()}");
        var map = document.data();
        if(FirebaseAuth.instance.currentUser!.email == document["email"])

        UserData = UserModel.fromJson(map as Map<String, dynamic>);

      });

      print("User email is : ${UserData!.email}");
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }

    notifyListeners();

  }

var iscalled = false;
  Future<void> fetchCurrentUSerPostFromFirestore() async {


    try {
      UserPostData.clear();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Recipes').where('email', isEqualTo:FirebaseAuth.instance.currentUser!.email)
          .get();
      querySnapshot.docs.reversed.forEach((document) async {
        // print("data = ${document.data()}");
        var map = document.data();
        if(FirebaseAuth.instance.currentUser!.email == document["email"])

          UserPostData.add(recipesDB.fromJson(map as Map<String, dynamic>));

      });
      iscalled = true;
      print("length is :${UserPostData.length}");

      print("User email is equal to Current user email");
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }

    notifyListeners();

  }



}