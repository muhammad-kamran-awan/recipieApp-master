import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipeapp/Global%20Models/RecipeModel.dart';
import 'package:http/http.dart' as http;
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/RecipeDetail/RecipeDetail.dart';
import 'package:recipeapp/View/RecipeDetail/recipeDetailScreen.dart';
import 'package:recipeapp/View/Widgets/TrandingRecipeContainer.dart';
import 'package:recipeapp/main.dart';

class RandomRecipes extends StatefulWidget {
  const RandomRecipes({super.key});

  @override
  State<RandomRecipes> createState() => _RandomRecipesState();
}

class _RandomRecipesState extends State<RandomRecipes> {
  // Define a list to store the fetched recipes
  List<Recipes> recipeList = [];

  Future<RecipeModel> fetchData(String apiKey, int number) async {
    final Uri uri = Uri.parse('https://api.spoonacular.com/recipes/random');
    final Map<String, String> params = {
      'apiKey': apiKey,
      'number': number.toString(),
    };

    final response = await http.get(uri.replace(queryParameters: params));

    if (response.statusCode == 200) {
      print("Status code is equal to 200");

      print("Response body: ${response.body}");
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
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Recipes"),
      ),
      body: FutureBuilder<RecipeModel>(
        future: fetchData("3190c737146b4168b65a7cf77f729edf", 20),
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
              return RecipeListWidget(recipes: recipes);
            } else {
              return Text('No recipes available.');
            }
          } else {
            return Text('No data available.');
          }
        },
      ),
    );
  }
}

class RecipeListWidget extends StatelessWidget {
  final List<Recipes> recipes;

  RecipeListWidget({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsive(240, context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final ingredients = recipe.extendedIngredients;
          final analyzedInst = recipe.analyzedInstructions;

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
                      builder: (context) => RecipeDetailScreen(
                            cookingTime: recipe.readyInMinutes ?? "20",
                            Serving: recipe.servings ?? "5",
                            analyzedInstructions: recipe.analyzedInstructions,
                            image: recipe.image ??
                                "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
                            title: recipe.title ?? "No title",
                            ingredients: recipe.extendedIngredients,
                            instructions: recipe.instructions ??
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
  }
}

class IngredientsList extends StatelessWidget {
  final List<ExtendedIngredients> ingredients;

  IngredientsList({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: ingredients.map((ingredient) {
              return Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 5, top: 5),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.network(
                                        "https://spoonacular.com/cdn/ingredients_500x500/" +
                                            ingredient.image.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ingredient.nameClean.toString() ??
                                      "Name not Available",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Text(ingredient.measures.metric.amount
                                        .toString() ??
                                    "Data not available"),
                                Text(ingredient.unit.toString() ??
                                    "Data not available"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class AnalyzedInstructionList extends StatelessWidget {
  final List<AnalyzedInstructions> analyzedInstructions;

  AnalyzedInstructionList({required this.analyzedInstructions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Analyzed Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: analyzedInstructions.map((AnalyzedInstruction) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 170,
                  // color: Colors.amber,
                  child: Builder(builder: (context) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(AnalyzedInstruction.steps.toString()),
                            Text(
                              AnalyzedInstruction.name ?? "Name not Available",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
