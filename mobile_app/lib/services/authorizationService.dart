import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mw_inside/services/storageService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mw_inside/config.dart';

// Login
Future<bool> login(String username, String password) async {
  print("l");
  final response = await http.post(
    Uri.http(SERVER_URL, '/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );
  print("r");
  print(jsonDecode(response.body));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      await storeTokens(data['accessToken'], data['refreshToken']);
      await storeUsername(username);
      return true;
    }
  }
  return false;
}

Future<void> checkTokens() async {
  print('check');
  Map tokens = await readTokens();
  if (tokens['refreshToken'] == null) {
    await logOut();
    return;
  }
  if (tokens['accessToken'] == null) {
    await refresh();
    return;
  }
  bool verified = await verify();
  if (!verified) {
    await refresh();
  }
}


// Register
Future<bool> register(String username, String password) async {
  final response = await http.post(
    Uri.http(SERVER_URL, '/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      await storeTokens(data['accessToken'], data['refreshToken']);
      return true;
    }
  }
  return false;
}

Future<void> logOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('refreshToken');
  prefs.remove('accessToken');
}

// Refresh
Future<bool> refresh() async {
  Map tokens = await readTokens();
  final response = await http.post(
    Uri.http(SERVER_URL, '/auth/refresh'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'refreshToken': tokens['refreshToken']}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      await storeAccessToken(data['accessToken']);
      return true;
    }
  }
  return false;
}

// Verify
Future<bool> verify() async {
  Map tokens = await readTokens();
  if (tokens['accessToken'] == null) {
    return false;
  }
  String accessToken=tokens['accessToken'];
  final response = await http.post(
    Uri.http(SERVER_URL, '/auth/verify'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'accessToken': accessToken}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['success'];
  }
  return false;
}
