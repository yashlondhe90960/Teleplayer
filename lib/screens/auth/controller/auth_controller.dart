import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthController {
  Future<String> login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse('http://159.65.242.239/user/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    return response.body;
  }

  Future<String> register(String email, String password, String name) async {
    http.Response response = await http.post(
      Uri.parse('http://159.65.242.239/user/register'),
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
    );
    return response.body;
  }
}
