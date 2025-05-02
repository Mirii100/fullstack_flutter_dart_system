import 'dart:io';

import '../config/api_config.dart';
import '../models/profile.dart';
import 'api_services.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  Future<Profile> getCurrentProfile() async {
    final response = await _apiService.get(ApiConfig.currentProfileUrl);
    return Profile.fromJson(response);
  }

  Future<Profile> updateProfile(Profile profile) async {
    final response = await _apiService.patch(
      '${ApiConfig.profileUrl}${profile.id}/',
      profile.toJson(),
    );
    return Profile.fromJson(response);
  }

  Future<Profile> uploadProfilePicture(int profileId, File imageFile) async {
    final response = await _apiService.uploadFile(
      '${ApiConfig.profileUrl}$profileId/',
      'profile_picture',
      imageFile,
      fields: {
        '_method': 'PATCH',
      },
    );
    return Profile.fromJson(response);
  }}