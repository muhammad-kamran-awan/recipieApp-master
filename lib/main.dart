import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/View/Home/View/providerlogic.dart';
// import com.google.android.gms.ads.MobileAds;
// import 'package:google.android.gms.ads.initialization.InitializationStatus';

import 'View/Spash/SplashScreen.dart';

var prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-1678002206864752~3953461648');
  // MobileAds.instance.initialize();
  await Firebase.initializeApp();
  // prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FoodDBProvider().loadJsonData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => providerLogic(),
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: Splash(),
        ),
      ),
    );
  }
}

String baseUrl = "https://api.spoonacular.com";
