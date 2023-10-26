import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:recipeapp/Global%20Models/RecipeModel.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Home/View/newScreen.dart';

class RecipeDetailScreen extends StatefulWidget {
  String image;
  String title;
  var cookingTime;
  var Serving;
  String instructions;
  final List<ExtendedIngredients> ingredients;
  final List<AnalyzedInstructions> analyzedInstructions;
  RecipeDetailScreen(
      {required this.Serving,
      required this.cookingTime,
      required this.image,
      required this.title,
      required this.ingredients,
      required this.analyzedInstructions,
      required this.instructions,
      super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Color? ingCuisineText = Colors.white;
  Color? procedureCuisineText = Color(0xFF119475);
  bool isIngredientVisible = true;
  bool isProcedureVisible = false;

  Color? ingcuisineContainer = Color(0xFF119475);
  Color? procedureCuisineContainer = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        bottomOpacity: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: SizedBox(
                width: responsive(400, context),
                height: responsive(250, context),
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(widget.image),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0, // Adjust the position as needed
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
                        top: 10.0, // Adjust the position as needed
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
          ),
          HeadingText(
              text: widget.title.toString(),
              color: Colors.black,
              context: context),
          SizedBox(
            height: 20,
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
                  setState(() {
                    procedureCuisineContainer = Color(0xFF119475);
                    procedureCuisineText = Colors.white;
                    ingCuisineText = Color(0xFF119475);
                    ingcuisineContainer = Colors.white;
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
          SizedBox(
            height: 20,
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
                      text: widget.Serving.toString() + " Serve",
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
                          text: widget.analyzedInstructions[0].steps.length
                                  .toString() +
                              " Steps",
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
              child: IngredientsList(ingredients: widget.ingredients)),
          Visibility(
            visible: isProcedureVisible,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: 500,
                    child: ListView.builder(
                        itemCount: widget.analyzedInstructions[0].steps.length,
                        itemBuilder: (context, index) {
                          var instructions = widget.analyzedInstructions[0];

                          return Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, bottom: 5, top: 5),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 15, bottom: 15, right: 8, left: 8),
                                width: 350,
                                // height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HeadingText(
                                        text: "Step " +
                                            instructions.steps[index].number
                                                .toString(),
                                        color: Colors.black,
                                        context: context),
                                    Text(
                                      instructions.steps[index].step.toString(),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        }),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
