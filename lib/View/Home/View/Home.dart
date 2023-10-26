import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/Global Styles/TextFiles.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipeapp/Global%20Models/RecipeModel.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Home/View/providerlogic.dart';
import 'package:recipeapp/View/Home/View/recipeSearchpage.dart';
import 'package:recipeapp/View/Home/View/singleton.dart';
import 'package:recipeapp/View/RecipeDetail/newRecipeDetail.dart';
import 'package:recipeapp/View/RecipeDetail/recipeDetailScreen.dart';
import 'package:recipeapp/View/Saved%20Recipies/SavedRecipies.dart';
import 'package:recipeapp/View/Widgets/NewRecipeWidget.dart';
import 'package:recipeapp/View/Widgets/TrandingRecipeContainer.dart';
import 'package:recipeapp/uploadRecipe.dart';

import '../../Profile/Profile.dart';
import '../../Widgets/CustomBottomAppbar.dart';
import '../../authentication/Login.dart';
import 'package:http/http.dart' as http;

final List<String> _svgIcons = [
  'images/home.svg',
  'images/save.svg',
  'images/profile.svg',
  'images/exit.svg',
];

// Create an instance of the Random class
// final random = Random();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selected = 0;
  int _selectedIndex = 0;
  var pages = [
    const Home(),
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
  void rebuildHomeScreen() {
    setState(() {
      // Update your state here if necessary
    });
  }

  List cuisinesList = [
    "Indian",
    "American",
    "European",
    "Asian",
    "Thai",
    "Spanish",
    "Chinese",
  ];
  List<Recipes> recipeList = [];
  String? _userName;
  String? _userImageUrl;
  String? mealType = "main course";
  String? cuisines = "Indian,Asian,Italian,  European,Thai, American, Chinese";
  TextEditingController searchController = TextEditingController();

  // For Cuisines Containers
  Color? allcuisineContainer = Color(0xFF119475);
  Color? firstCuisineContainer = Colors.white;
  Color? secondCuisineContainer = Colors.white;
  Color? thirdCuisineContainer = Colors.white;
  Color? fourthCuisineContainer = Colors.white;
  Color? fifthCuisineContainer = Colors.white;
  Color? sixthCuisineContainer = Colors.white;

  // for cuisines text
  Color? allCuisineText = Colors.white;
  Color? firstCuisineText = Color(0xFF119475);
  Color? secondCuisineText = Color.fromARGB(255, 85, 155, 138);
  Color? thirdCuisineText = Color(0xFF119475);
  Color? fourthCuisineText = Color(0xFF119475);
  Color? fifthCuisineText = Color(0xFF119475);
  Color? sixthCuisineText = Color(0xFF119475);

// function for getting data from api

  // Variable to track the current screen

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingText(
                          text: _userName != null
                              ? 'Hello, $_userName'
                              : 'Hello', // Display user's name if available
                          context: context,
                        ),
                        SizedBox(
                          height: 5,
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
                  height: responsive(35, context),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          currentScreen = "search";
                          Get.to(RecipeSearchPage());
                        },
                        child: Container(
                          width: 240,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.search_sharp,
                                size: 30,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Search any recipe",
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                )),
                              ),
                              const SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFF119475),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.sort,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 10,
                ),
                // for meal types

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              currentScreen = 'home';
                              cuisines = cuisines;
                              allcuisineContainer = Color(0xFF119475);

                              firstCuisineContainer = Colors.white;
                              secondCuisineContainer = Colors.white;
                              thirdCuisineContainer = Colors.white;
                              fourthCuisineContainer = Colors.white;
                              fifthCuisineContainer = Colors.white;
                              sixthCuisineContainer = Colors.white;

                              allCuisineText = Colors.white;
                              firstCuisineText = Color(0xFF119475);
                              secondCuisineText = Color(0xFF119475);
                              thirdCuisineText = Color(0xFF119475);
                              fourthCuisineText = Color(0xFF119475);
                              fifthCuisineText = Color(0xFF119475);
                              sixthCuisineText = Color(0xFF119475);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                color: allcuisineContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: normalText(
                                  text: "All",
                                  context: context,
                                  color: allCuisineText),
                              //   child: Text(
                              // "All",
                              // style: TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 10,
                              // ),
                              // )
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              currentScreen = 'home';
                              cuisines = "Indian";
                              allcuisineContainer = Colors.white;

                              firstCuisineContainer = Color(0xFF119475);
                              secondCuisineContainer = Colors.white;
                              thirdCuisineContainer = Colors.white;
                              fourthCuisineContainer = Colors.white;
                              fifthCuisineContainer = Colors.white;
                              sixthCuisineContainer = Colors.white;

                              allCuisineText = Color(0xFF119475);
                              firstCuisineText = Colors.white;
                              secondCuisineText = Color(0xFF119475);
                              thirdCuisineText = Color(0xFF119475);
                              fourthCuisineText = Color(0xFF119475);
                              fifthCuisineText = Color(0xFF119475);
                              sixthCuisineText = Color(0xFF119475);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                color: firstCuisineContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: normalText(
                                    text: "Indian",
                                    context: context,
                                    color: firstCuisineText)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              cuisines = "Italian";
                              currentScreen = 'home';

                              firstCuisineContainer = Colors.white;
                              allcuisineContainer = Colors.white;
                              secondCuisineContainer = Color(0xFF119475);
                              thirdCuisineContainer = Colors.white;
                              fourthCuisineContainer = Colors.white;
                              fifthCuisineContainer = Colors.white;
                              sixthCuisineContainer = Colors.white;

                              allCuisineText = Color(0xFF119475);
                              firstCuisineText = Color(0xFF119475);
                              secondCuisineText = Colors.white;
                              thirdCuisineText = Color(0xFF119475);
                              fourthCuisineText = Color(0xFF119475);
                              fifthCuisineText = Color(0xFF119475);
                              sixthCuisineText = Color(0xFF119475);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                color: secondCuisineContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: normalText(
                                    context: context,
                                    color: secondCuisineText,
                                    text: "Italian")),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              cuisines = "Asian";
                              currentScreen = 'home';
                              // thirdContainerColor = Color(0xFF119475);
                              firstCuisineContainer = Colors.white;
                              allcuisineContainer = Colors.white;
                              secondCuisineContainer = Colors.white;
                              thirdCuisineContainer = Color(0xFF119475);
                              fourthCuisineContainer = Colors.white;
                              fifthCuisineContainer = Colors.white;
                              sixthCuisineContainer = Colors.white;

                              allCuisineText = Color(0xFF119475);
                              firstCuisineText = Color(0xFF119475);
                              secondCuisineText = Color(0xFF119475);
                              thirdCuisineText = Colors.white;
                              fourthCuisineText = Color(0xFF119475);
                              fifthCuisineText = Color(0xFF119475);
                              sixthCuisineText = Color(0xFF119475);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                color: thirdCuisineContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: normalText(
                                    text: "Asian",
                                    color: thirdCuisineText,
                                    context: context)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              cuisines = "European";
                              currentScreen = 'home';
                              firstCuisineContainer = Colors.white;
                              secondCuisineContainer = Colors.white;
                              thirdCuisineContainer = Colors.white;
                              allcuisineContainer = Colors.white;
                              fourthCuisineContainer = Color(0xFF119475);
                              fifthCuisineContainer = Colors.white;
                              sixthCuisineContainer = Colors.white;

                              allCuisineText = Color(0xFF119475);
                              firstCuisineText = Color(0xFF119475);
                              secondCuisineText = Color(0xFF119475);
                              thirdCuisineText = Color(0xFF119475);
                              fourthCuisineText = Colors.white;
                              fifthCuisineText = Color(0xFF119475);
                              sixthCuisineText = Color(0xFF119475);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                color: fourthCuisineContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: normalText(
                                    text: "European",
                                    color: fourthCuisineText,
                                    context: context)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              cuisines = "Thai";
                              currentScreen = 'home';
                              firstCuisineContainer = Colors.white;
                              secondCuisineContainer = Colors.white;
                              thirdCuisineContainer = Colors.white;
                              fourthCuisineContainer = Colors.white;
                              allcuisineContainer = Colors.white;
                              fifthCuisineContainer = Color(0xFF119475);
                              sixthCuisineContainer = Colors.white;

                              allCuisineText = Color(0xFF119475);
                              firstCuisineText = Color(0xFF119475);
                              secondCuisineText = Color(0xFF119475);
                              thirdCuisineText = Color(0xFF119475);
                              fourthCuisineText = Color(0xFF119475);
                              fifthCuisineText = Colors.white;
                              sixthCuisineText = Color(0xFF119475);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                color: fifthCuisineContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: normalText(
                              text: "Thai",
                              color: fifthCuisineText,
                              context: context,
                            )),
                          ),
                        ),
                      ),
                      // for chinese recipes
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              cuisines = "Chinese";
                              currentScreen = 'home';
                              firstCuisineContainer = Colors.white;
                              secondCuisineContainer = Colors.white;
                              thirdCuisineContainer = Colors.white;
                              fourthCuisineContainer = Colors.white;
                              fifthCuisineContainer = Colors.white;
                              allcuisineContainer = Colors.white;
                              sixthCuisineContainer = const Color(0xFF119475);

                              allCuisineText = const Color(0xFF119475);
                              firstCuisineText = const Color(0xFF119475);
                              secondCuisineText = const Color(0xFF119475);
                              thirdCuisineText = const Color(0xFF119475);
                              fourthCuisineText = const Color(0xFF119475);
                              fifthCuisineText = const Color(0xFF119475);
                              sixthCuisineText = Colors.white;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                color: sixthCuisineContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: normalText(
                              text: "Chinese",
                              color: sixthCuisineText,
                              context: context,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Consumer<providerLogic>(
                  builder: (context, value, child) =>
                      FutureBuilder<RecipeModel>(
                    future: value.fetchData("d9616493b6c747ec9f8ad5c95bdfe10e",
                        100, "$mealType,$cuisines", currentScreen),
                    builder: (context, snapshot) {
                      print("Fetch Data is working");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          child: Center(
                              child: SpinKitCircle(
                            color: Color(0xFF119475),
                            size: 75,
                          )),
                        );
                      } else if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'We apologize, but there are currently no recipes available for your request. Try a different search to discover new recipes.',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        );
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
                                final AnalyzedInstructions =
                                    recipe.analyzedInstructions;

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
                                                  analyzedInstructions:
                                                      AnalyzedInstructions,
                                                  cookingTime:
                                                      recipe.readyInMinutes ??
                                                          "20",
                                                  Serving:
                                                      recipe.servings ?? "5",
                                                  image: recipe.image ??
                                                      "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
                                                  title: recipe.title ??
                                                      "No title",
                                                  ingredients: recipe
                                                      .extendedIngredients,
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
                          return const Text('No recipes available.');
                        }
                      } else {
                        return const Text('No data available.');
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Recipes",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchRecipesWithUserNames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: SpinKitCircle(
                        color: Color(0xFF119475),
                        size: 75,
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No recipes available.');
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

String currentScreen = 'home';
