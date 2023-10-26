import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Home/View/Home.dart';
import 'package:recipeapp/View/RecipeDetail/newRecipeDetail.dart';
import 'package:recipeapp/View/Widgets/NewRecipeWidget.dart';
import 'package:recipeapp/View/authentication/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _userImage;
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await fetchUserData(user.uid);
      if (userData != null) {
        setState(() {
          _userImageUrl = userData['profileImageURL'];
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecipesWithUserNames() async {
    try {
      final QuerySnapshot recipesSnapshot =
          await FirebaseFirestore.instance.collection('recipes').get();

      final List<Map<String, dynamic>> recipesWithUserNames = [];
      print("Recipes");
      print(recipesWithUserNames.toString());

      for (final recipeDocument in recipesSnapshot.docs) {
        final userId = recipeDocument['UserId'];
        final userDocument = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        if (userDocument.exists) {
          final userName = userDocument['name'];
          final userImage = userDocument['profileImageURL'];

          final recipeData = recipeDocument.data() as Map<String, dynamic>;
          recipeData['UserName'] = userName;
          recipeData['UserImage'] = userImage;
          recipesWithUserNames.add(recipeData);
        }
      }

      return recipesWithUserNames;
    } catch (e) {
      print('Error fetching recipes with user names: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return {
            'name': data['name'],
            'profileImageURL': data[
                'profileImageURL'], // Assuming 'profileImageURL' is the field storing the image URL
          };
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null; // Return null in case of an error or if the document doesn't exist
  }

  Future<void> _uploadImage(String uid) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);

      try {
        final firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(uid);

        final firebase_storage.UploadTask uploadTask =
            storageReference.putFile(imageFile);

        final firebase_storage.TaskSnapshot downloadURL = (await uploadTask);
        final String imageURL = await downloadURL.ref.getDownloadURL();

        // Now you have the imageURL, update it in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'profileImageURL': imageURL,
        });

        setState(() {
          _userImage = File(pickedImage.path);
          _userImageUrl = imageURL;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Profile",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black),
            ),
            SizedBox(
              width: 110,
            ),
            Visibility(
              visible:
                  user != null, // Show the button only when user is logged in
              child: InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                },
                child: Container(
                  child: Center(
                      child: Icon(
                    Icons.logout,
                    color: Color(0xFF119475),
                  )),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                // User is not logged in
                return Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                          height: 300,
                          width: 300,
                          child: Image.asset("images/emp.jpg")),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'You are not logged in.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Color(0xFF119475),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                // User is logged in
                final user = snapshot.data!;
                return FutureBuilder<Map<String, dynamic>?>(
                  future: fetchUserData(user.uid),
                  builder: (context, nameSnapshot) {
                    if (nameSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitCircle(
                        color: Color(0xFF119475),
                        size: 75,
                      );
                    } else if (nameSnapshot.hasError) {
                      return Text('Error: ${nameSnapshot.error}');
                    } else {
                      final userData = nameSnapshot.data!;
                      final userName = userData['name'];
                      final userImage = userData['profileImageURL'];
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 25, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      _userImageUrl == null
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  AssetImage("images/user.jpg"),
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  NetworkImage(_userImageUrl!),
                                            ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: InkWell(
                                          onTap: () {
                                            _uploadImage(user.uid);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF119475),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$userName',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                "Happy to have you with us",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Color(0xFF119475),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text(
                                  "Recipes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: fetchRecipesWithUserNames(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: SpinKitCircle(
                                    color: Color(0xFF119475),
                                    size: 75,
                                  ));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Text('No recipes available.');
                                } else {
                                  final recipes = snapshot.data;
                                  return Container(
                                    height: responsive(240, context),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recipes!.length,
                                      itemBuilder: (context, index) {
                                        final recipe = recipes[index];
                                        final userName = recipe['UserName'];
                                        final userImage = recipe['UserImage'];
                                        final title = recipe['title'];
                                        final ingredients =
                                            recipe['Ingredients'];
                                        final instructions =
                                            recipe['Instructions'];
                                        final serving = recipe['Serving'];
                                        final cookingTime = recipe['ReadyIn'];
                                        final image = recipe['ImageUrl'];
                                        final recipeid = recipe['RecipeId'];

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          newRecipeDetail(
                                                            cookingTime:
                                                                cookingTime ??
                                                                    "20",
                                                            recipeId: recipeid,
                                                            serving:
                                                                serving ?? "5",
                                                            image: image ??
                                                                "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
                                                            title: title ??
                                                                "No title",
                                                            ingredients:
                                                                ingredients,
                                                            instructions:
                                                                instructions ??
                                                                    "No Instructions Available",
                                                            isRecipeFavorite:
                                                                false,
                                                          )),
                                                );
                                              },
                                              child: NewRecipe(
                                                name: title,
                                                autherImage: userImage,
                                                url: image,
                                                auther: userName,
                                                cookingTime: cookingTime,
                                              )),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => MainPage()),
                            //     );
                            //   },
                            //   child: Container(
                            //     height: 50,
                            //     width: 120,
                            //     decoration: BoxDecoration(
                            //         color: Color(0xFF119475),
                            //         border: Border.all(
                            //           color: Colors.white,
                            //         ),
                            //         borderRadius: BorderRadius.circular(12)),
                            //     child: Center(
                            //       child: Text(
                            //         "Explore More",
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
