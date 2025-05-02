import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


import 'auth_services.dart';

class ApiService {
  final AuthService _authService = AuthService();

  // GET request
  Future<dynamic> get(String url) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
    );

    return _processResponse(response);
  }

  // POST request
  Future<dynamic> post(String url, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode(data),
    );

    return _processResponse(response);
  }

  // PUT request
  Future<dynamic> put(String url, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode(data),
    );

    return _processResponse(response);
  }

  // PATCH request
  Future<dynamic> patch(String url, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode(data),
    );

    return _processResponse(response);
  }

  // DELETE request
  Future<dynamic> delete(String url) async {
    final token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
    );

    return _processResponse(response, acceptEmpty: true);
  }

  // Upload file with multipart request
  Future<dynamic> uploadFile(String url, String fieldName, File file, {Map<String, String>? fields}) async {
    final token = await _authService.getToken();

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add authorization header
    if (token != null) {
      request.headers['Authorization'] = 'Token $token';
    }

    // Add file
    request.files.add(await http.MultipartFile.fromPath(
      fieldName,
      file.path,
    ));

    // Add other fields if any
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _processResponse(response);
  }

  // Process HTTP response
  dynamic _processResponse(http.Response response, {bool acceptEmpty = false}) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty && acceptEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }
}