import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/View/Widgets/TrandingRecipeContainer.dart';

class FirebaseDataScreen extends StatefulWidget {
  const FirebaseDataScreen({super.key});

  @override
  State<FirebaseDataScreen> createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
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
          final recipeData = recipeDocument.data() as Map<String, dynamic>;
          recipeData['UserName'] = userName;
          recipesWithUserNames.add(recipeData);
        }
      }

      return recipesWithUserNames;
    } catch (e) {
      print('Error fetching recipes with user names: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Data"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRecipesWithUserNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No recipes available.');
          } else {
            final recipes = snapshot.data;
            return ListView.builder(
              itemCount: recipes!.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final userName = recipe['UserName'];
                final title = recipe['title'];
                final ingredients = recipe['Ingredients'];
                final instructions = recipe['Instructions'];
                final serving = recipe['Serving'];
                final cookingTime = recipe['ReadyIn'];
                final image = recipe['ImageUrl'];

                return TrendingRecipe(
                    url: image, time: cookingTime, name: title);
              },
            );
          }
        },
      ),
    );
  }
}
