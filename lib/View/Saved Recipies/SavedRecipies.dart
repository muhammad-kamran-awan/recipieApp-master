import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/RecipeDetail/newRecipeDetail.dart';
import 'package:recipeapp/View/Widgets/NewRecipeWidget.dart';
import 'package:recipeapp/View/Widgets/TrandingRecipeContainer.dart';

class SavedRecipes extends StatefulWidget {
  @override
  State<SavedRecipes> createState() => _SavedRecipesState();
}

class _SavedRecipesState extends State<SavedRecipes> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Recipes"),
        backgroundColor: Colors.green[600],
      ),
      body: Column(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchUserFavoriteRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Container(
                        child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                                height: 300,
                                width: 300,
                                child: Image.asset("images/emp.jpg")),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'No favorite recipes available',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                  ),
                );
              } else {
                final favoriteRecipes = snapshot.data;

                // Display the user's favorite recipes as needed
                return Container(
                  height: responsive(240, context),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: favoriteRecipes!.length,
                    itemBuilder: (context, index) {
                      final recipe = favoriteRecipes[index];
                      final userName = recipe['UserName'];
                      final title = recipe['title'];
                      final ingredients = recipe['Ingredients'];
                      final instructions = recipe['Instructions'];
                      final serving = recipe['Serving'];
                      final cookingTime = recipe['ReadyIn'];
                      final image = recipe['ImageUrl'];
                      final recipeid = recipe['RecipeId'];
                      // Display recipe details
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => newRecipeDetail(
                                          cookingTime: cookingTime ?? "20",
                                          recipeId: recipeid,
                                          serving: serving ?? "5",
                                          image: image ??
                                              "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
                                          title: title ?? "No title",
                                          ingredients: ingredients,
                                          instructions: instructions ??
                                              "No Instructions Available",
                                          isRecipeFavorite: true,
                                        )),
                              );
                            },
                            child: TrendingRecipe(
                              name: title,
                              url: image,
                              // auther: userName,
                              time: cookingTime,
                            )),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
