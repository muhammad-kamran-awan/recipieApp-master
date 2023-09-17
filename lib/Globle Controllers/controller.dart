import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Global Models/Model.dart';
import '../services/admobservice.dart';

class FoodDBProvider extends ChangeNotifier {
  List<recipesDB> dataa = [];
  List<dynamic> _jsonData = [];
  var searchKeyword = "";




  var adds;
  void UpdatingSearch(value) {
    searchKeyword = value;
    notifyListeners();
  }
  //-------------------------banner Ad--------------------------------//
  late List<BannerAd> bannerAd,profileBadd,procedureBad,ingrBad;
   bool isAdLoaded = false;
  bool ispAdLoaded = false;
  bool isiAdLoaded = false;
  bool ispcAdLoaded = false;
  void setAllToNull(){
     isAdLoaded = false;
     ispAdLoaded = false;
     isiAdLoaded = false;
     ispcAdLoaded = false;
     notifyListeners();
  }

  void initBannerAdshome() {
    bannerAd = List.generate(
      10,
      // Number of banner ads you want to display
      (index) => BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerAdUnitId!,

        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Ad loaded');
            isAdLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Ad failed to load because of $error");
          },
        ),
        request: AdRequest(),
      )..load(),
    );
    notifyListeners();
  }
  void initBannerAds_ingred() {
    ingrBad = List.generate(
      3,
      // Number of banner ads you want to display
          (index) => BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerAdUnitId!,

        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Ad loaded');
            isiAdLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Ad failed to load because of $error");
          },
        ),
        request: AdRequest(),
      )..load(),
    );
    notifyListeners();
  }
  void initBannerAds_procedue() {
    procedureBad = List.generate(
      3,
      // Number of banner ads you want to display
          (index) => BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerAdUnitId!,

        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Ad loaded');
            ispcAdLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Ad failed to load because of $error");
          },
        ),
        request: AdRequest(),
      )..load(),
    );
    notifyListeners();
  }
  void initBannerAds_profile() {
    profileBadd = List.generate(
      20,
      // Number of banner ads you want to display
          (index) => BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerAdUnitId!,

        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Ad loaded');
            ispAdLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Ad failed to load because of $error");
          },
        ),
        request: AdRequest(),
      )..load(),
    );
    notifyListeners();
  }



  //-------------------------Native  Ad--------------------------------//

  // late List<NativeAd> nativeAd;
  // bool isNativeAdLoaded = false;
  //
  // void initNativeAd() {
  //   nativeAd = List.generate(
  //     50,
  //     // Number of Native ads you want to display
  //         (index) =>
  //     NativeAd(
  //       adUnitId: AdmobService.nativeAdUnitId!,
  //
  //       listener: NativeAdListener(
  //         onAdLoaded: (ad) {
  //           print('Native Ad loaded');
  //           isNativeAdLoaded = true;
  //         },
  //         onAdFailedToLoad: (ad, error) {
  //           print("Native Ad failed to load because of $error");
  //           ad.dispose();
  //         },
  //       ),
  //       request: AdRequest(),
  //     )..load(),
  //   );
  //   notifyListeners();
  // }







  //--------------------------------------------------------------------//
  List<dynamic> get jsonData => _jsonData;

  Future<void> loadJsonData() async {
    try {
      var jsonString = await rootBundle.loadString('assets/foodDB.json');
      var jsonData = jsonDecode(jsonString);
      for (var map in jsonData) {
        dataa.add(recipesDB.fromJson(map));

        notifyListeners();
      }

      print(dataa![0].name!);
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      dataa.clear();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Recipes')
          .orderBy('time')
          .get();
      querySnapshot.docs.reversed.forEach((document) async {
        // print("data = ${document.data()}");
        var map = document.data();

        dataa.add(recipesDB.fromJson(map as Map<String, dynamic>));
      });
      loadJsonData();
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }
    print(dataa[0].author);
    notifyListeners();
  }



//  --------------------- local Storage ------------------------//

  Future<void> saveToSharedPreferences(data) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = json.encode(data);

    // Use a unique key to save the recipe data
    final key = 'saved';
print(" data is :${jsonString}");
    prefs.setString(key, jsonString);
    notifyListeners();
  }
// var data =
//
//   void  loadFromSharedPreferences(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // Use the same unique key used during saving
//     final key = 'saved';
//     final jsonString = prefs.getString(key);
//     print("json is : ${jsonString}");
//
//     // if (jsonString != null) {
//     //   final jsonData = json.decode(jsonString);
//     //   return recipesDB.fromJson(jsonData);
//     // }
//
//
//   };









}
