import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:http/http.dart' as http;
import 'package:recipeapp/Global%20Models/SearchRecipeModel.dart';
import 'package:recipeapp/Global%20Models/searchrecipeInformation.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Home/View/controller.dart';
import 'package:recipeapp/View/Home/View/textinput.dart';
import 'package:recipeapp/View/Home/View/Home.dart';
import 'package:recipeapp/View/RecipeDetail/recipeDetailScreen.dart';
import 'package:recipeapp/View/Widgets/CustomAddTextField.dart';
import 'package:recipeapp/View/Widgets/searchResultWidget.dart';
import 'package:async/async.dart';

class RecipeSearchPage extends StatefulWidget {
  @override
  State<RecipeSearchPage> createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  final TextEditingController searchController = TextEditingController();
  final counterController controller = Get.put(counterController());

  var email;

  final TextEditingController _controller = TextEditingController();

  final String searchStatus = "Recent Search";

  String? cuisines = "Indian,Asian,Italian,European,Thai,American,Chinese";

  final String? mealType = "main course";

  String searchtext = "burger";

  final List<String> cuisineList = [
    'Indian',
    'Asian',
    'Italian',
    'European',
    'Thai',
    'American',
    'Chinese'
  ];

  Future<SearchRecipeModel> fetchSearchData(
      String apiKey, String query, String tags) async {
    print("search recipe api running");
    final Uri uri =
        Uri.parse('https://api.spoonacular.com/recipes/complexSearch');
    final Map<String, String> params = {
      'apiKey': apiKey,
      'query': query,
      'tags': tags,
    };

    final response = await http.get(uri.replace(queryParameters: params));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final SearchRecipeModel searchRecipeModel =
          SearchRecipeModel.fromJson(data);
      return searchRecipeModel;
    } else if (response.statusCode == 401) {
      throw Exception("Server didn't Authorize");
    } else {
      throw Exception(
          'API Request Failed - Status Code: ${response.statusCode}');
    }
  }

  Future<RecipeModel> fetchRecipeInformationById(
      String apiKey, int recipeId) async {
    print("fetch recipe by id working ");
    final Uri uri =
        Uri.parse('https://api.spoonacular.com/recipes/$recipeId/information');
    final Map<String, String> params = {
      'apiKey': apiKey,
    };

    try {
      final response = await http.get(uri.replace(queryParameters: params));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final RecipeModel recipeModel = RecipeModel.fromJson(data);
        return recipeModel;
      } else if (response.statusCode == 401) {
        throw Exception("Server didn't Authorize");
      } else {
        throw Exception(
            'API Request Failed - Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch recipe: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        shadowColor: Colors.white,
        title: HeadingText(
            text: "Search Recipes", context: context, color: Colors.black),
        centerTitle: true,
        leading: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: InkWell(
            onTap: () {
              print(currentScreen);
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     border: Border.all(color: Colors.grey),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   height: 40,
                  //   width: 250,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 10),
                  //     child: Center(
                  //       child: TextFormField(
                  //         textAlign: TextAlign.start,
                  //         initialValue: "Burger",
                  //         onFieldSubmitted: (value) {
                  //           searchtext = value;
                  //         },
                  //         decoration: InputDecoration(
                  //           icon: Icon(
                  //             Icons.search,
                  //             color: Colors.grey[400],
                  //           ),
                  //           hintText: "Search Recipes",
                  //           hintStyle: TextStyle(
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.grey[400]),
                  //           border: OutlineInputBorder(
                  //             borderSide: BorderSide.none,
                  //             borderRadius: BorderRadius.circular(15.0),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5.0, left: 5),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(50)),
                              child: Container(
                                height: 400,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        HeadingText(
                                            text: "Filter Search",
                                            context: context,
                                            color: Colors.black),
                                        Container(
                                          height: 350,
                                          child: ListView.builder(
                                              itemCount: cuisineList.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: MediumText(
                                                      text: cuisineList[index],
                                                      context: context,
                                                      color: Colors.grey[600]),
                                                  onTap: () {
                                                    cuisines =
                                                        cuisineList[index];
                                                    print(cuisines);
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF119475),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),

              TextFormField(
                controller: controller.searchController.value,
                key: UniqueKey(),
              )
              // FutureBuilder<SearchRecipeModel>(
              //   future: fetchSearchData("3190c737146b4168b65a7cf77f729edf4",
              //       searchtext.toString(), "$mealType,$cuisines"),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const SizedBox(
              //         child: Center(
              //           child: SpinKitCircle(
              //             color: Color(0xFF119475),
              //             size: 75,
              //           ),
              //         ),
              //       );
              //     } else if (snapshot.hasError) {
              //       return Column(
              //         children: [
              //           Image.asset(
              //             "images/emp.jpg",
              //             height: 350,
              //             width: 200,
              //           ),
              //           const Padding(
              //             padding: EdgeInsets.all(8.0),
              //             child: Text(
              //               'We apologize, but there are currently no recipes available for your request. Check back later for more delicious options.',
              //               style: TextStyle(fontSize: 16, color: Colors.red),
              //             ),
              //           ),
              //         ],
              //       );
              //     } else if (snapshot.hasData) {
              //       final searchRecipeModel = snapshot.data!;
              //       List<Results>? results = searchRecipeModel.results;

              //       if (results != null && results.isNotEmpty) {
              //         return Container(
              //           height: responsive(740, context),
              //           child: GridView.builder(
              //             gridDelegate:
              //                 const SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount:
              //                   2, // Adjust the number of columns as needed
              //               crossAxisSpacing:
              //                   5.0, // Adjust the spacing between columns as needed
              //               mainAxisSpacing:
              //                   8.0, // Adjust the spacing between rows as needed
              //             ),
              //             itemCount: results.length,
              //             itemBuilder: (context, index) {
              //               final result = results[index];

              //               return Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: InkWell(
              //                   onTap: () async {
              //                     const String apiKey =
              //                         'd9616493b6c747ec9f8ad5c95bdfe10e';
              //                     final int? recipeId = result.id;

              //                     try {
              //                       final RecipeModel recipe =
              //                           await fetchRecipeInformationById(
              //                               apiKey, recipeId!);
              //                       print('Recipe Title: ${recipe.title}');
              //                       Get.to(RecipeDetailScreen(
              //                         cookingTime:
              //                             recipe.readyInMinutes ?? "20",
              //                         Serving: recipe.servings ?? "5",
              //                         image: recipe.image ??
              //                             "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg",
              //                         title: recipe.title ?? "No title",
              //                         ingredients: recipe.extendedIngredients,
              //                         analyzedInstructions:
              //                             recipe.analyzedInstructions,
              //                         instructions: recipe.instructions ??
              //                             "No Instructions Available",
              //                       ));
              //                     } catch (e) {
              //                       print('Error fetching recipe: $e');
              //                     }
              //                   },
              //                   child: SearchResultRecipe(
              //                     url: result.image,
              //                     name: result.title,
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         );
              //       } else {
              //         return Text('No search results available.');
              //       }
              //     } else {
              //       return Text('No data available.');
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
