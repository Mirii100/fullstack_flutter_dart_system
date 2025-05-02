class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

class AuthResponse {
  final String token;
  final int userId;
  final String email;
  final String username;
  final String firstName;
  final String lastName;

  AuthResponse({
    required this.token,
    required this.userId,
    required this.email,
    required this.username,
    this.firstName = '',
    this.lastName = '',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      userId: json['user_id'],
      email: json['email'] ?? '',
      username: json['username'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}