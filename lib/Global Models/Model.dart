

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class recipesDB {
  var name;
  var email;
  var url;
  var description;
  var author;
  var time;
  List<String>? ingredients;
  List<String>? method;

  recipesDB(
      {this.name,
      this.email,
        this.time,
        this.url,
        this.description,
        this.author,
        this.ingredients,
        this.method});

  recipesDB.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    email = json['email'];
    url = json['url'];
    description = json['Description'];
    time = json['timetaken'];
    author = json['Author'];
    ingredients = json['Ingredients'].cast<String>();
    method = json['Method'].cast<String>();
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['email'] = this.email;
    data['url'] = this.url;
    data['Description'] = this.description;
    data['Author'] = this.author;
    data['Ingredients'] = this.ingredients;
    data['Method'] = this.method;
    data['timetaken'] = this.time;
    return data;
  }



  static List<recipesDB> searchByName(List<recipesDB> recipes, String keyword) {
    return recipes
        .where((recipe) => recipe.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  //-------------------localStorage---------------------------------//




}
