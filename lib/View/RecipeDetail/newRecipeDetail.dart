import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/authentication/Login.dart';
import 'package:recipeapp/utils/utils.dart';

class newRecipeDetail extends StatefulWidget {
  String image;
  String title;
  String instructions;
  final bool isRecipeFavorite;
  List ingredients;
  String cookingTime;
  String serving;
  String recipeId;

  newRecipeDetail(
      {required this.image,
      required this.isRecipeFavorite,
      required this.ingredients,
      required this.instructions,
      required this.title,
      required this.cookingTime,
      required this.serving,
      required this.recipeId,
      super.key});

  @override
  State<newRecipeDetail> createState() => _newRecipeDetailState();
}

class _newRecipeDetailState extends State<newRecipeDetail> {
  bool _showIngredients = false;
  Color? ingCuisineText = Colors.white;
  Color? procedureCuisineText = Color(0xFF119475);
  bool isIngredientVisible = true;
  bool isProcedureVisible = false;
  late List<String> steps;
  Color? ingcuisineContainer = Color(0xFF119475);
  Color? procedureCuisineContainer = Colors.white;

  bool isFavorite = false;

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<Map<String, dynamic>>> fetchUserFavoriteRecipes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return [];
      }

      final userUid = user.uid;
      final userFavoritesRef =
          FirebaseFirestore.instance.collection('Favorites').doc(userUid);
      final userFavoritesDoc = await userFavoritesRef.get();

      if (!userFavoritesDoc.exists) {
        return [];
      }

      final favoriteRecipeUids =
          List<String>.from(userFavoritesDoc.data()?['favoriteRecipes'] ?? []);

      if (favoriteRecipeUids.isEmpty) {
        return [];
      }

      final QuerySnapshot recipesSnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where(FieldPath.documentId, whereIn: favoriteRecipeUids)
          .get();

      final List<Map<String, dynamic>> favoriteRecipes = [];

      for (final recipeDocument in recipesSnapshot.docs) {
        favoriteRecipes.add(recipeDocument.data() as Map<String, dynamic>);
      }
      print(favoriteRecipes.toString());

      return favoriteRecipes;
    } catch (e) {
      print('Error fetching user favorite recipes: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isRecipeFavorite == false) {
      fetchUserFavoriteRecipes().then((favoriteRecipes) {
        final isRecipeFavorite = favoriteRecipes
            .any((recipe) => recipe['recipeId'] == widget.recipeId);
        setState(() {
          isFavorite = isRecipeFavorite;
        });
      });
    } else {
      isFavorite = widget.isRecipeFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    steps = widget.instructions.split('\n');
    int a = 0;
    final nonEmptySteps =
        steps.where((step) => step.trim().isNotEmpty).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        bottomOpacity: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: SizedBox(
                width: responsive(400, context),
                height: responsive(400, context),
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.image,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null)
                              return child; // Display the image if it's already loaded.
                            return SpinKitCircle(
                              color: Color(0xFF119475),
                              size: 75,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20.0, // Adjust the position as needed
                      right: 20.0, // Adjust the position as needed
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_sharp,
                            color: Colors.white,
                          ),
                          Text(
                            widget.cookingTime.toString() + " min",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 20.0, // Adjust the position as needed
                        right: 15.0, // A
                        child: Container(
                          width: responsive(45, context),
                          height: responsive(20, context),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive(4, context),
                            vertical: responsive(3, context),
                          ),
                          decoration: ShapeDecoration(
                            color: Color(0xFFFFE1B3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xffFFAD30),
                                size: responsive(15, context),
                              ),
                              smallText(
                                  text: "4.5",
                                  color: Colors.black,
                                  context: context),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      smallText(
                          text: widget.serving.toString() + " Serve",
                          context: context,
                          color: Colors.grey)
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        Get.to(Login());
                        return;
                      }

                      final userUid = user.uid;
                      final recipeUid = widget.recipeId;
                      final userFavoritesRef = FirebaseFirestore.instance
                          .collection('Favorites')
                          .doc(userUid);

                      final docSnapshot = await userFavoritesRef.get();

                      if (!docSnapshot.exists) {
                        await userFavoritesRef.set({'favoriteRecipes': []});
                      }

                      if (isFavorite) {
                        await userFavoritesRef.update({
                          'favoriteRecipes':
                              FieldValue.arrayRemove([recipeUid]),
                        });
                      } else {
                        await userFavoritesRef.update({
                          'favoriteRecipes': FieldValue.arrayUnion([recipeUid]),
                        });
                      }

                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 35,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                  width: 300,
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      ingcuisineContainer = Color(0xFF119475);
                      ingCuisineText = Colors.white;
                      procedureCuisineText = Color(0xFF119475);
                      procedureCuisineContainer = Colors.white;
                      isIngredientVisible = true;
                      isProcedureVisible = false;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 130,
                    decoration: BoxDecoration(
                        color: ingcuisineContainer,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: MediumText(
                          text: "Ingredients",
                          color: ingCuisineText,
                          context: context),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print(widget.instructions.split('\n'));
                    setState(() {
                      ingCuisineText = Color(0xFF119475);
                      ingcuisineContainer = Colors.white;
                      procedureCuisineContainer = Color(0xFF119475);
                      procedureCuisineText = Colors.white;
                      isIngredientVisible = false;
                      isProcedureVisible = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 130,
                    decoration: BoxDecoration(
                        color: procedureCuisineContainer,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: MediumText(
                          text: "Procedure",
                          color: procedureCuisineText,
                          context: context),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    smallText(
                        text: widget.serving.toString() + " Serve",
                        context: context,
                        color: Colors.grey),
                  ],
                ),
                Row(
                  children: [
                    Builder(builder: (context) {
                      if (isIngredientVisible) {
                        return smallText(
                            text: widget.ingredients.length.toString() +
                                " Ingredients",
                            context: context,
                            color: Colors.grey);
                      } else {
                        return smallText(
                            text: nonEmptySteps.length.toString() + " Steps",
                            context: context,
                            color: Colors.grey);
                      }
                    }),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: isIngredientVisible,
              child: SingleChildScrollView(
                child: Container(
                  height: 550,
                  child: ListView.builder(
                    itemCount: widget.ingredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      int serialNumber = index + 1;
                      String ingredient = widget.ingredients[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 5, top: 5),
                        child: Container(
                          width: 350,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 20),
                                MediumlargeText(
                                  text: '$serialNumber.',
                                  context: context,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 30),
                                MediumText(
                                  text: ingredient,
                                  context: context,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isProcedureVisible,
              child: SingleChildScrollView(
                child: Container(
                  height: 550,
                  child: ListView.builder(
                    itemCount: nonEmptySteps.length,
                    itemBuilder: (BuildContext context, int index) {
                      int stepnumber = index + 1;
                      String step = nonEmptySteps[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 5, top: 5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, right: 8, left: 8),
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 20),
                                MediumlargeText(
                                  text: "Step " + stepnumber.toString(),
                                  context: context,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 30),
                                Text(
                                  step,
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
