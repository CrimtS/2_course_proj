import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Initialize categories map
Map<String, bool> categories = {
  'Red square object': false,
  'government building': false,
  'mall': false,
  'monument': false,
  'museum': false,
  'religious building': false,
  'restaurant': false,
  'skyscraper': false,
  'stadium': false,
  'theatre': false,
};

// Function to store categories
Future<void> storeCategories() async {
  final prefs = await SharedPreferences.getInstance();

  categories.forEach((key, value) async {
    await prefs.setBool(key, value);
  });
}

// Function to get categories
Future<Map<String, bool>> getCategories() async {
  final prefs = await SharedPreferences.getInstance();

  Map<String, bool> loadedCategories = {};
  categories.keys.forEach((key) {
    var value = prefs.getBool(key) ?? false;  // default value is false
    loadedCategories[key] = value;
  });
  return loadedCategories;
}

// Function to update a category
Future<void> updateCategory(String key, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  print("Updated "+key+" to "+value.toString());
  await prefs.setBool(key, value);
}

// Store access and refresh tokens
Future<void> storeTokens(String accessToken, String refreshToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  await prefs.setString('refreshToken', refreshToken);
}

Future<void> storeUsername(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

Future<String> readUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
Future<void> saveNotificationsRadius(int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('radius updated to '+value.toString());
  prefs.setInt('notificationsRadius', value);
}

Future<int> getNotificationsRadius() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int value = prefs.getInt('notificationsRadius') ?? 20; // defaults to 20 if not set
  return value;
}


// Store access token
Future<void> storeAccessToken(String accessToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
}
Future<List<String>> buildFilterArray() async {
  Map<String, bool> categories = await getCategories();
  List<String> testAns= categories.entries
      .where((entry) => entry.value == true)
      .map((entry) => entry.key)
      .toList();
  if(testAns.isEmpty){
    return categories.entries
        .map((entry) => entry.key)
        .toList();
  }
  else
    return testAns;
}


Future<Map<String, String>> readTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accessToken = prefs.getString('accessToken');
  String refreshToken = prefs.getString('refreshToken');
  return {'accessToken': accessToken, 'refreshToken': refreshToken};
}