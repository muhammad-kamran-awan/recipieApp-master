import 'package:flutter/material.dart';
import 'package:recipeapp/Global%20Models/RecipeModel.dart';
import 'package:recipeapp/View/Home/View/newScreen.dart';

class RecipeDetailScreen extends StatefulWidget {
  String image;
  String title;
  var cookingTime;
  var Serving;
  String instructions;
  final List<ExtendedIngredients> ingredients;
  RecipeDetailScreen(
      {required this.Serving,
      required this.cookingTime,
      required this.image,
      required this.title,
      required this.ingredients,
      required this.instructions,
      super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
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
                    child: Image.network(widget.image),
                  ),
                ),
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
                            widget.Serving.toString(),
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
            IngredientsList(ingredients: widget.ingredients),
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
