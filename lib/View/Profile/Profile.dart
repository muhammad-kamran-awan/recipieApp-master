import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipeapp/View/Home/View/Home.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Profile'),
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
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.green[600],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                        height: 30,
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
                              color: Colors.green[800],
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
                        return CircularProgressIndicator();
                      } else if (nameSnapshot.hasError) {
                        return Text('Error: ${nameSnapshot.error}');
                      } else {
                        final userData = nameSnapshot.data!;
                        final userName = userData['name'];
                        final userImage = userData['profileImageURL'];
                        return Column(
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
                                        color: Colors.green,
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
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'Welcome, $userName',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              "Happy to have you with us",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Text(
                                    "Let's Explore",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
