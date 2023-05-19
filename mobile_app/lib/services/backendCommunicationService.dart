import 'package:mw_inside/config.dart';
import 'package:http/http.dart' as http;
import 'package:mw_inside/services/storageService.dart';
import 'dart:convert';
import 'authorizationService.dart';

Future<dynamic> serverRequest(String type, String url, Map data) async {
  print('request: ' + url);
  String authData;
  Map tokens = await readTokens();
  String accessToken = tokens['accessToken'];
  authData = "Bearer " + accessToken;

  final String dataJson = jsonEncode(data);

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": authData,
  };

  http.Response response;
  if (type == "post") {
    response = await http.post(
      Uri.http(SERVER_URL, url),
      headers: headers,
      body: dataJson,
    );
  } else if (type == "get") {
    response = await http.get(
      Uri.http(SERVER_URL, url),
      headers: headers,
    );
  }
  if (response.statusCode == 401) {
    checkTokens();
    refresh();
    serverRequest(type, url, data);
  }
  String body = utf8.decode(response.bodyBytes);
  print(jsonDecode(body));
  return jsonDecode(body);
}

Future<List> getNearbyObjects(Map data) async {
  String authData;
  Map tokens = await readTokens();
  String accessToken = tokens['accessToken'];
  authData = "Bearer " + accessToken;
  final String dataJson = jsonEncode(data);
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Authorization": authData,
  };
  http.Response response;
  response = await http.post(
    Uri.http(SERVER_URL, '/geo_objects/get_nearby_objects'),
    headers: headers,
    body: dataJson,
  );
  String body = utf8.decode(response.bodyBytes);
  print(jsonDecode(body));
  return jsonDecode(body);
}
Future<List> searchObjects(Map data) async {
  String authData;
  Map tokens = await readTokens();
  String accessToken = tokens['accessToken'];
  authData = "Bearer " + accessToken;
  final String dataJson = jsonEncode(data);
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Authorization": authData,
  };
  http.Response response;
  response = await http.post(
    Uri.http(SERVER_URL, '/geo_objects/search'),
    headers: headers,
    body: dataJson,
  );
  String body = utf8.decode(response.bodyBytes);
  print(jsonDecode(body));
  return jsonDecode(body);
}
