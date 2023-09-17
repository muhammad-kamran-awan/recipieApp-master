import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/Global%20Models/RecipeModel.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Home/View/firebasedata.dart';
import 'package:recipeapp/View/Home/View/newScreen.dart';
import 'package:recipeapp/View/RecipeDetail/newRecipeDetail.dart';
import 'package:recipeapp/View/RecipeDetail/recipeDetailScreen.dart';
import 'package:recipeapp/View/Saved%20Recipies/SavedRecipies.dart';
import 'package:recipeapp/View/Widgets/NewRecipeWidget.dart';
import 'package:recipeapp/View/Widgets/TrandingRecipeContainer.dart';
import 'package:recipeapp/uploadRecipe.dart';

import '../../../Global Styles/TextFiles.dart';
import '../../../Globle Controllers/controller.dart';
import '../../../Globle Controllers/userdataclass.dart';
import '../../Add Recipe/AddRecipe.dart';
import '../../Notifications/Notifications.dart';
import '../../Profile/Profile.dart';
import '../../Widgets/CustomBottomAppbar.dart';
import '../../Widgets/SearchWidget.dart';
import '../../authentication/Login.dart';
import '/../../Global Models/Model.dart';
import 'package:http/http.dart' as http;

final List<String> _svgIcons = [
  'images/home.svg',
  'images/save.svg',
  'images/profile.svg',
  'images/exit.svg',
];
var selected = 0;
// Create an instance of the Random class
final random = Random();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selected = 0;
  int _selectedIndex = 0;
  var pages = [
    Home(),
    SavedRecipes(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            //   resizeToAvoidBottomInset: false, // fluter 1.x
            resizeToAvoidBottomInset: false,
            // backgroundColor: Colors.white60,
            floatingActionButton: InkWell(
              onTap: () {
                FirebaseAuth.instance.currentUser == null
                    ? Get.to(Login())
                    : Get.to(UploadRecipeScreen());
              },
              child: CircleAvatar(
                backgroundColor: Color(0xFF119475),
                radius: responsive(30, context),
                child: Icon(
                  Icons.add,
                  size: responsive(25, context),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: CurvedNavigationBar(
                selectedIndex: _selectedIndex,
                items: _svgIcons.map((iconPath) {
                  return SvgPicture.asset(
                    height: responsiveDesign(28, context),
                    width: responsiveDesign(28, context),
                    iconPath,
                    color: _selectedIndex == _svgIcons.indexOf(iconPath)
                        ? Color(0xFF119475).withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                  );
                }).toList(),
                onTap: (index) {
                  if (index == _svgIcons.length - 1) {
                    // If the exit icon is tapped, call the handleExit function
                    handleExit();
                  } else {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }
                }),
            body: pages[_selectedIndex]));
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recipes> recipeList = [];
  String? _userName;
  String? _userImageUrl;

// function for getting data from api
  Future<RecipeModel> fetchData(String apiKey, int number, String tags) async {
    final Uri uri = Uri.parse('https://api.spoonacular.com/recipes/random');
    final Map<String, String> params = {
      'apiKey': apiKey,
      'number': number.toString(),
      'tags': tags
    };

    final response = await http.get(uri.replace(queryParameters: params));

    if (response.statusCode == 200) {
      print("Status code is equal to 200");
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> data = json.decode(response.body);
      print("data");
      print(data);
      final RecipeModel recipeModel = RecipeModel.fromJson(data);
      print("recipe Model");
      print(recipeModel.toString());
      return recipeModel;
    } else if (response.statusCode == 401) {
      throw Exception("Server didn't Authorize");
    } else {
      print('API Request Failed - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }

// function for getting data from firebase

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
          _userName = userData['name'];
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
            'profileImageURL': data['profileImageURL'],
          };
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  var addindex;
  var search = "";

  // function for getting user information

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: responsiveDesign(20, context),
            vertical: responsiveDesign(10, context)),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HeadingText(
                          text: _userName != null
                              ? 'Hello, $_userName'
                              : 'Hello', // Display user's name if available
                          context: context,
                        ),
                        smallText(
                          text: 'What are you cooking today?',
                          context: context,
                          color: Color(0xFFA9A9A9),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(ProfileScreen());
                        // Get.to(Login());
                      },
                      child: Container(
                        width: responsive(45, context),
                        height: responsive(50, context),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFCE80).withOpacity(0),
                          borderRadius:
                              BorderRadius.circular(responsive(10, context)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(responsive(15, context))),
                          child: _userImageUrl != null
                              ? CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "images/user.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                  imageUrl: _userImageUrl!,
                                  fit: BoxFit.fitWidth,
                                )
                              : Image.asset(
                                  "images/user.jpg",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: responsive(20, context),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Popular Recipes",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      height: 3,
                      width: 150,
                      color: Colors.green,
                    )
                  ],
                ),
                FutureBuilder<RecipeModel>(
                  future: fetchData("3190c737146b4168b65a7cf77f729edf", 100,
                      "main course,Indian"),
                  builder: (context, snapshot) {
                    print("Fetch Data is working");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final recipeModel = snapshot.data!;
                      List<Recipes> recipes =
                          recipeModel.recipes; // No need for null check

                      if (recipes.isNotEmpty) {
                        // Check if recipes list is not empty
                        return Container(
                          height: responsive(240, context),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              final ingredients = recipe.extendedIngredients;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    print("Extended Ingredients");
                                    print(ingredients.toString());
                                    print("Cuisines");
                                    print(recipe.cuisines.toString());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecipeDetailScreen(
                                                cookingTime:
                                                    recipe.readyInMinutes ??
                                                        "20",
                                                Serving: recipe.servings ?? "5",
                                                image: recipe.image ??
                                                    "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
                                                title:
                                                    recipe.title ?? "No title",
                                                ingredients:
                                                    recipe.extendedIngredients,
                                                instructions: recipe
                                                        .instructions ??
                                                    "No Instructions Available",
                                              )),
                                    );
                                  },
                                  child: TrendingRecipe(
                                      url: recipe.image ??
                                          "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
                                      time: recipe.readyInMinutes ?? "20",
                                      name: recipe.title ?? "No title"),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text('No recipes available.');
                      }
                    } else {
                      return Text('No data available.');
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Recipes",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      height: 3,
                      width: 120,
                      color: Colors.green,
                    )
                  ],
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchRecipesWithUserNames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                            final ingredients = recipe['Ingredients'];
                            final instructions = recipe['Instructions'];
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
                                          builder: (context) => newRecipeDetail(
                                                cookingTime:
                                                    cookingTime ?? "20",
                                                recipeId: recipeid,
                                                serving: serving ?? "5",
                                                image: image ??
                                                    "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
                                                title: title ?? "No title",
                                                ingredients: ingredients,
                                                instructions: instructions ??
                                                    "No Instructions Available",
                                                isRecipeFavorite: false,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void handleExit() {
  // Use SystemNavigator.pop() to exit the app
  SystemNavigator.pop();
}
