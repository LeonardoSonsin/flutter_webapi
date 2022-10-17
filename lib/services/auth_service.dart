import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  http.Client client = WebClient().client;
  String url = WebClient.url;

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}login"),
        body: {"email": email, "password": password});

    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFoundException();
      }
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);
    return true;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}register"),
        body: {"email": email, "password": password});

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);
    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = json.decode(body);

    String token = map["accessToken"];
    int id = map["user"]["id"];
    String email = map["user"]["email"];

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("accessToken", token);
    preferences.setInt("id", id);
    preferences.setString("email", email);
  }
}

class UserNotFoundException implements Exception {}
