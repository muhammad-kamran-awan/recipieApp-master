import 'dart:convert';

import 'package:recipeapp/Global%20Models/RecipeModel.dart';
import 'package:http/http.dart' as http;

Future<RecipeModel> fetchData(
  String apiKey,
  int number,
  String tags,
  String currentScreen,
) async {
  print("trying to hit home screen api");
  if (currentScreen == 'home') {
    print("Running Home api");
    final Uri uri = Uri.parse('https://api.spoonacular.com/recipes/random');
    final Map<String, String> params = {
      'apiKey': apiKey,
      'number': number.toString(),
      'tags': tags
    };

    final response = await http.get(uri.replace(queryParameters: params));

    if (response.statusCode == 200) {
      print("home page random api working");
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
      throw Exception("Api is not sending data");
    }
  } else {
    print("not on home screen");
    throw Exception("Not on home scren");
  }
}
