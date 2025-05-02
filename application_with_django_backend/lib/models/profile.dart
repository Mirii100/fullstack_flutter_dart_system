//import 'package:marketplace_app/config/api_config.dart';

import '../config/api_config.dart';

class Profile {
  final int id;
  final int userId;
  final String username;
  final String email;
  final String? profilePicture;
  final String bio;
  final String location;
  final String dateJoined;

  Profile({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    this.profilePicture,
    required this.bio,
    required this.location,
    required this.dateJoined,
  });

  String get fullProfilePictureUrl {
    if (profilePicture == null || profilePicture!.isEmpty) {
      return '';
    }
    return '${ApiConfig.baseUrl}$profilePicture';
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profile_picture'],
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      dateJoined: json['date_joined'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'location': location,
    };
  }
}