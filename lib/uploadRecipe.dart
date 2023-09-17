import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadRecipeScreen extends StatefulWidget {
  UploadRecipeScreen({super.key});

  @override
  State<UploadRecipeScreen> createState() => _UploadRecipeScreenState();
}

class _UploadRecipeScreenState extends State<UploadRecipeScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController cookingTimeController = TextEditingController();
  TextEditingController servingController = TextEditingController();
  List<String> ingredients = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ingredientController = TextEditingController();
  String _imageText = "Please Select Your Recipe Image";
  final uuid = Uuid();

  File? recipeImage;

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> uploadRecipeToFirestore(
    String title,
    String instruction,
    String serving,
    String cookingTime,
    List<String> ingredients,
    String imageUrl,
  ) async {
    try {
      // Get the currently authenticated user's ID
      final String? userId = getCurrentUserId();

      if (userId == null) {
        // Handle the case where no user is authenticated
        return;
      }

      // Reference to your Firestore collection
      final CollectionReference recipesCollection =
          FirebaseFirestore.instance.collection('recipes');

      // Generate a UUID for the recipe
      final String recipeUid = uuid.v4(); // Generates a random UUID

      // Define the data to upload
      final Map<String, dynamic> recipeData = {
        'RecipeId': recipeUid, // Include the UUID for the recipe
        'UserId': userId, // Associate the user's ID with the recipe
        'Ingredients': ingredients,
        'Instructions': instruction,
        'ReadyIn': cookingTime,
        'Serving': serving,
        'title': title,
        'ImageUrl': imageUrl,
      };

      // Add the document to the collection
      await recipesCollection.doc(recipeUid).set(recipeData);

      print('Recipe data uploaded to Firestore successfully!');
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Recipe uploaded successfully!'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    } catch (e) {
      print('Error uploading recipe data to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<File> getFromGallery() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return File(pickedFile!.path);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Upload Recipe"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Recipe Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title is required';
                    }
                  },
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Enter Recipe Title",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              // Recipe Ingredients
              Text(
                "Ingredients",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              // List of ingredients

              ListView.builder(
                shrinkWrap: true,
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ingredients[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          ingredients.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Expanded(
                          child: TextFormField(
                            controller: ingredientController,
                            decoration: InputDecoration(
                              hintText: "Enter an ingredient with Amount",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (ingredientController.text.isNotEmpty) {
                            setState(() {
                              ingredients.add(ingredientController.text);
                              ingredientController.clear();
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 75,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),
              Text(
                "Recipe Cooking Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Cooking Time is required';
                    }
                  },
                  controller: cookingTimeController,
                  decoration: InputDecoration(
                    hintText: "Enter Recipe Cooking Time in Minutes",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Serving",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Serving is required';
                    }
                  },
                  controller: servingController,
                  decoration: InputDecoration(
                    hintText: "Enter Recipe Serving",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Recipe Instructions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: TextFormField(
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Instructions are required';
                    }
                  },
                  controller: instructionsController,
                  decoration: InputDecoration(
                    hintText: "Enter Recipe Instructions",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),
              Text(
                "Recipe Image",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(_imageText),
                      InkWell(
                        onTap: () async {
                          final pickedImage = await getFromGallery();

                          setState(() {
                            recipeImage = pickedImage;
                          });
                          _imageText = "Image selected successfully";
                        },
                        child: Container(
                          height: 40,
                          width: 75,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Browse",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Display the selected image
              recipeImage != null
                  ? Container(
                      height: 100, width: 200, child: Image.file(recipeImage!))
                  : Container(),

              SizedBox(
                height: 10,
              ),

              InkWell(
                onTap: () async {
                  if (recipeImage == null) {
                    // Show an error message or prevent the upload if no image is selected.
                    return;
                  }

                  // Upload the image to Firebase Storage
                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('recipe_images/${DateTime.now()}.jpg');
                  final uploadTask = storageRef.putFile(recipeImage!);

                  // Get the download URL of the uploaded image
                  final TaskSnapshot taskSnapshot = await uploadTask;
                  final imageUrl = await taskSnapshot.ref.getDownloadURL();

                  uploadRecipeToFirestore(
                    titleController.text,
                    instructionsController.text,
                    servingController.text,
                    cookingTimeController.text,
                    ingredients,
                    imageUrl,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 50,
                  width: 120,
                  child: Center(
                    child: Text(
                      "Upload Recipe",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
