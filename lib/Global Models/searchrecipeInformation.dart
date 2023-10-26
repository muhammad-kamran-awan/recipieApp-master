import 'RecipeModel.dart';

class RecipeModel {
  RecipeModel({
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
    required this.dairyFree,
    required this.veryHealthy,
    required this.cheap,
    required this.veryPopular,
    required this.sustainable,
    required this.lowFodmap,
    required this.weightWatcherSmartPoints,
    required this.gaps,
    required this.preparationMinutes,
    required this.cookingMinutes,
    required this.aggregateLikes,
    required this.healthScore,
    required this.creditsText,
    required this.license,
    required this.sourceName,
    required this.pricePerServing,
    required this.extendedIngredients,
    required this.id,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.image,
    required this.sourceUrl,
    required this.summary,
    required this.cuisines,
    required this.dishTypes,
    required this.diets,
    required this.occasions,
    required this.instructions,
    required this.analyzedInstructions,
    this.originalId,
    required this.spoonacularSourceUrl,
  });

  late final bool? vegetarian;
  late final bool? vegan;
  late final bool? glutenFree;
  late final bool? dairyFree;
  late final bool? veryHealthy;
  late final bool? cheap;
  late final bool? veryPopular;
  late final bool? sustainable;
  late final bool? lowFodmap;
  late final int? weightWatcherSmartPoints;
  late final String? gaps;
  late final int? preparationMinutes;
  late final int? cookingMinutes;
  late final int? aggregateLikes;
  late final int? healthScore;
  late final String? creditsText;
  late final String? license;
  late final String? sourceName;
  late final double? pricePerServing;
  late final List<ExtendedIngredients> extendedIngredients;
  late final int? id;
  late final String? title;
  late final int? readyInMinutes;
  late final int? servings;
  late final String? image;
  late final String? sourceUrl;
  late final String? summary;
  late final List<String> cuisines;
  late final List<String> dishTypes;
  late final List<String> diets;
  late final List<String> occasions;
  late final String? instructions;
  late final List<AnalyzedInstructions> analyzedInstructions;
  late final String? originalId;
  late final String? spoonacularSourceUrl;

  RecipeModel.fromJson(Map<String, dynamic> json) {
    vegetarian = json['vegetarian'];
    vegan = json['vegan'];
    glutenFree = json['glutenFree'];
    dairyFree = json['dairyFree'];
    veryHealthy = json['veryHealthy'];
    cheap = json['cheap'];
    veryPopular = json['veryPopular'];
    sustainable = json['sustainable'];
    lowFodmap = json['lowFodmap'];
    weightWatcherSmartPoints = json['weightWatcherSmartPoints'];
    gaps = json['gaps'];
    preparationMinutes = json['preparationMinutes'];
    cookingMinutes = json['cookingMinutes'];
    aggregateLikes = json['aggregateLikes'];
    healthScore = json['healthScore'];
    creditsText = json['creditsText'];
    license = json['license'];
    sourceName = json['sourceName'];
    pricePerServing = json['pricePerServing'];
    extendedIngredients = List<ExtendedIngredients>.from(
        json['extendedIngredients']
            .map((x) => ExtendedIngredients.fromJson(x)));
    id = json['id'];
    title = json['title'];
    readyInMinutes = json['readyInMinutes'];
    servings = json['servings'];
    image = json['image'];
    sourceUrl = json['sourceUrl'];
    summary = json['summary'];
    cuisines = List<String>.from(json['cuisines']);
    dishTypes = List<String>.from(json['dishTypes']);
    diets = List<String>.from(json['diets']);
    occasions = List<String>.from(json['occasions']);
    instructions = json['instructions'];
    analyzedInstructions = List<AnalyzedInstructions>.from(
        json['analyzedInstructions']
            .map((x) => AnalyzedInstructions.fromJson(x)));
    originalId = json['originalId'];
    spoonacularSourceUrl = json['spoonacularSourceUrl'];
  }

  RecipeModel.fromSingleRecipe(Map<String, dynamic> json) {
    vegetarian = json['vegetarian'];
    vegan = json['vegan'];
    glutenFree = json['glutenFree'];
    dairyFree = json['dairyFree'];
    veryHealthy = json['veryHealthy'];
    cheap = json['cheap'];
    veryPopular = json['veryPopular'];
    sustainable = json['sustainable'];
    lowFodmap = json['lowFodmap'];
    weightWatcherSmartPoints = json['weightWatcherSmartPoints'];
    gaps = json['gaps'];
    preparationMinutes = json['preparationMinutes'];
    cookingMinutes = json['cookingMinutes'];
    aggregateLikes = json['aggregateLikes'];
    healthScore = json['healthScore'];
    creditsText = json['creditsText'];
    license = json['license'];
    sourceName = json['sourceName'];
    pricePerServing = json['pricePerServing'];
    extendedIngredients = List<ExtendedIngredients>.from(
        json['extendedIngredients']
            .map((x) => ExtendedIngredients.fromJson(x)));
    id = json['id'];
    title = json['title'];
    readyInMinutes = json['readyInMinutes'];
    servings = json['servings'];
    image = json['image'];
    sourceUrl = json['sourceUrl'];
    summary = json['summary'];
    cuisines = List<String>.from(json['cuisines']);
    dishTypes = List<String>.from(json['dishTypes']);
    diets = List<String>.from(json['diets']);
    occasions = List<String>.from(json['occasions']);
    instructions = json['instructions'];
    analyzedInstructions = List<AnalyzedInstructions>.from(
        json['analyzedInstructions']
            .map((x) => AnalyzedInstructions.fromJson(x)));
    originalId = json['originalId'];
    spoonacularSourceUrl = json['spoonacularSourceUrl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['vegetarian'] = vegetarian;
    _data['vegan'] = vegan;
    _data['glutenFree'] = glutenFree;
    _data['dairyFree'] = dairyFree;
    _data['veryHealthy'] = veryHealthy;
    _data['cheap'] = cheap;
    _data['veryPopular'] = veryPopular;
    _data['sustainable'] = sustainable;
    _data['lowFodmap'] = lowFodmap;
    _data['weightWatcherSmartPoints'] = weightWatcherSmartPoints;
    _data['gaps'] = gaps;
    _data['preparationMinutes'] = preparationMinutes;
    _data['cookingMinutes'] = cookingMinutes;
    _data['aggregateLikes'] = aggregateLikes;
    _data['healthScore'] = healthScore;
    _data['creditsText'] = creditsText;
    _data['license'] = license;
    _data['sourceName'] = sourceName;
    _data['pricePerServing'] = pricePerServing;
    _data['extendedIngredients'] =
        extendedIngredients.map((e) => e.toJson()).toList();
    _data['id'] = id;
    _data['title'] = title;
    _data['readyInMinutes'] = readyInMinutes;
    _data['servings'] = servings;
    _data['sourceUrl'] = sourceUrl;
    _data['image'] = image;
    _data['summary'] = summary;
    _data['cuisines'] = cuisines;
    _data['dishTypes'] = dishTypes;
    _data['diets'] = diets;
    _data['occasions'] = occasions;
    _data['instructions'] = instructions;
    _data['analyzedInstructions'] =
        analyzedInstructions.map((e) => e.toJson()).toList();
    _data['originalId'] = originalId;
    _data['spoonacularSourceUrl'] = spoonacularSourceUrl;
    return _data;
  }
}
