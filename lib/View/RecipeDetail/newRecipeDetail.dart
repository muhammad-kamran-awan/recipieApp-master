import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  bool isFavorite = false; // Initially, ingredients are not shown.
  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<Map<String, dynamic>>> fetchUserFavoriteRecipes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return []; // No user is logged in
      }

      final userUid = user.uid;

      // Reference to the "Favorites" document for the user
      final userFavoritesRef =
          FirebaseFirestore.instance.collection('Favorites').doc(userUid);

      // Get the user's favorite recipes document
      final userFavoritesDoc = await userFavoritesRef.get();

      if (!userFavoritesDoc.exists) {
        return []; // User has no favorite recipes
      }

      // Get the array of favorite recipe UIDs
      final favoriteRecipeUids =
          List<String>.from(userFavoritesDoc.data()?['favoriteRecipes'] ?? []);

      if (favoriteRecipeUids.isEmpty) {
        return []; // User has no favorite recipes
      }

      // Query the "recipes" collection to fetch the details of favorite recipes
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

    // Fetch user's favorite recipes when the widget initializes
    if (widget.isRecipeFavorite == false) {
      fetchUserFavoriteRecipes().then((favoriteRecipes) {
        final isRecipeFavorite = favoriteRecipes
            .any((recipe) => recipe['recipeId'] == widget.recipeId);
        setState(() {
          isFavorite = isRecipeFavorite;
        });
      });
    } else {
      // Set the initial favorite status based on the provided value
      isFavorite = widget.isRecipeFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recipe Detail Screen")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Center(
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(20),
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl:
                          widget.image ?? "http://via.placeholder.com/350x150",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        // User is not logged in, navigate to the login screen
                        Get.to(Login());
                        return; // Exit the function early
                      }

                      final userUid = user.uid;
                      final recipeUid = widget.recipeId;
                      final userFavoritesRef = FirebaseFirestore.instance
                          .collection('Favorites')
                          .doc(userUid);

                      // Check if the "Favorites" document for the user exists
                      final docSnapshot = await userFavoritesRef.get();

                      if (!docSnapshot.exists) {
                        // The document doesn't exist, create it
                        await userFavoritesRef.set({'favoriteRecipes': []});
                      }

                      if (isFavorite) {
                        // If it's already a favorite, remove it
                        await userFavoritesRef.update({
                          'favoriteRecipes':
                              FieldValue.arrayRemove([recipeUid]),
                        });
                      } else {
                        // If it's not a favorite, add it
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

            SizedBox(
              height: 30,
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
              height: 20,
            ),
            Container(
              width: 300,
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.amber[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.cookingTime.toString() + "Mins",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("Ready In")
                        ],
                      ),
                      Container(
                        width: 2, // Width of the red line
                        height: 50, // Height of the red line
                        color: Colors.red, // Color of the red line
                      ),
                      Column(
                        children: [
                          Text(
                            widget.serving.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("Serving")
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            // Text("Ingredients"),
            // Ingredients ExpansionTile
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: Border.all(color: Colors.black),
                title: Text(
                  "Ingredients",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                trailing: Icon(
                  _showIngredients
                      ? Icons
                          .arrow_drop_up // Show the up arrow if ingredients are expanded
                      : Icons
                          .arrow_drop_down, // Show the down arrow if ingredients are collapsed
                ),
                onTap: () {
                  setState(() {
                    _showIngredients =
                        !_showIngredients; // Toggle the ingredients state
                  });
                },
              ),
            ),

// Ingredients content inside ExpansionTile
            if (_showIngredients)
              Padding(
                padding: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.ingredients
                            .map((ingredient) => Text(ingredient))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Instructions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(
                    height: 3,
                    width: 120,
                    color: Colors.red,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(widget.instructions),
            ),

            // for equiptments
          ],
        ),
      ),
    );
  }
}
