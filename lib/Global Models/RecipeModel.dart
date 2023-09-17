class RecipeModel {
  RecipeModel({
    required this.recipes,
  });

  late final List<Recipes> recipes;

  RecipeModel.fromJson(Map<String, dynamic> json) {
    recipes =
        List.from(json['recipes']).map((e) => Recipes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['recipes'] = recipes.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Recipes {
  Recipes({
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

  Recipes.fromJson(Map<String, dynamic> json) {
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

class ExtendedIngredients {
  ExtendedIngredients({
    required this.id,
    required this.aisle,
    required this.image,
    required this.consistency,
    required this.name,
    required this.nameClean,
    required this.original,
    required this.originalName,
    required this.amount,
    required this.unit,
    required this.meta,
    required this.measures,
  });

  late final int id;
  late final String? aisle;
  late final String? image;
  late final String? consistency;
  late final String? name;
  late final String? nameClean;
  late final String? original;
  late final String? originalName;
  late final double? amount;
  late final String? unit;
  late final List<String> meta;
  late final Measures measures;

  ExtendedIngredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aisle = json['aisle'];
    image = json['image'];
    consistency = json['consistency'];
    name = json['name'];
    nameClean = json['nameClean'];
    original = json['original'];
    originalName = json['originalName'];
    amount = json['amount'];
    unit = json['unit'];
    meta = List.castFrom<dynamic, String>(json['meta']);
    measures = Measures.fromJson(json['measures']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['aisle'] = aisle;
    _data['image'] = image;
    _data['consistency'] = consistency;
    _data['name'] = name;
    _data['nameClean'] = nameClean;
    _data['original'] = original;
    _data['originalName'] = originalName;
    _data['amount'] = amount;
    _data['unit'] = unit;
    _data['meta'] = meta;
    _data['measures'] = measures.toJson();
    return _data;
  }
}

class Measures {
  Measures({
    required this.us,
    required this.metric,
  });

  late final Us us;
  late final Metric metric;

  Measures.fromJson(Map<String, dynamic> json) {
    us = Us.fromJson(json['us']);
    metric = Metric.fromJson(json['metric']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['us'] = us.toJson();
    _data['metric'] = metric.toJson();
    return _data;
  }
}

class Us {
  Us({
    required this.amount,
    required this.unitShort,
    required this.unitLong,
  });

  late final double? amount;
  late final String? unitShort;
  late final String? unitLong;

  Us.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    unitShort = json['unitShort'];
    unitLong = json['unitLong'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['amount'] = amount;
    _data['unitShort'] = unitShort;
    _data['unitLong'] = unitLong;
    return _data;
  }
}

class Metric {
  Metric({
    required this.amount,
    required this.unitShort,
    required this.unitLong,
  });

  late final double? amount;
  late final String? unitShort;
  late final String? unitLong;

  Metric.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    unitShort = json['unitShort'];
    unitLong = json['unitLong'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['amount'] = amount;
    _data['unitShort'] = unitShort;
    _data['unitLong'] = unitLong;
    return _data;
  }
}

class AnalyzedInstructions {
  AnalyzedInstructions({
    required this.name,
    required this.steps,
  });

  late final String? name;
  late final List<Steps> steps;

  AnalyzedInstructions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    steps = List.from(json['steps']).map((e) => Steps.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['steps'] = steps.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Steps {
  Steps({
    required this.number,
    required this.step,
    required this.ingredients,
    required this.equipment,
  });

  late final int? number;
  late final String? step;
  late final List<Ingredients> ingredients;
  late final List<Equipment> equipment;

  Steps.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    step = json['step'];
    ingredients = List.from(json['ingredients'])
        .map((e) => Ingredients.fromJson(e))
        .toList();
    equipment =
        List.from(json['equipment']).map((e) => Equipment.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['number'] = number;
    _data['step'] = step;
    _data['ingredients'] = ingredients.map((e) => e.toJson()).toList();
    _data['equipment'] = equipment.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Ingredients {
  Ingredients({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.image,
  });

  late final int id;
  late final String name;
  late final String localizedName;
  late final String image;

  Ingredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    localizedName = json['localizedName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['localizedName'] = localizedName;
    _data['image'] = image;
    return _data;
  }
}

class Equipment {
  Equipment({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.image,
  });

  late final int? id;
  late final String? name;
  late final String? localizedName;
  late final String? image;

  Equipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    localizedName = json['localizedName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['localizedName'] = localizedName;
    _data['image'] = image;
    return _data;
  }
}

class SpoonacularSourceUrl {
  SpoonacularSourceUrl({
    required this.name,
    required this.steps,
  });

  late final String? name;
  late final List<Steps> steps;

  SpoonacularSourceUrl.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    steps = List.from(json['steps']).map((e) => Steps.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['steps'] = steps.map((e) => e.toJson()).toList();
    return _data;
  }
}
