import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';
import '../models/user.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  // Register a new user
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    String firstName = '',
    String lastName = '',
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    if (response.statusCode == 201) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveAuthData(authResponse);
      return authResponse;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Login a user
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveAuthData(authResponse);
      return authResponse;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Logout the current user
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userDataKey);
  }

  // Save auth data to secure storage
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _storage.write(key: _tokenKey, value: authResponse.token);

    final userData = {
      'userId': authResponse.userId,
      'username': authResponse.username,
      'email': authResponse.email,
      'firstName': authResponse.firstName,
      'lastName': authResponse.lastName,
    };

    await _storage.write(key: _userDataKey, value: jsonEncode(userData));
  }

  // Get the saved auth token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Check if a user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get the current user data
  Future<User?> getCurrentUser() async {
    final userData = await _storage.read(key: _userDataKey);
    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return User(
        id: userMap['userId'],
        username: userMap['username'],
        email: userMap['email'] ?? '',
        firstName: userMap['firstName'] ?? '',
        lastName: userMap['lastName'] ?? '',
      );
    }
    return null;
  }
}