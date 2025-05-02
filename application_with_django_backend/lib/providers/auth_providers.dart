import 'package:flutter/foundation.dart';

import '../models/profile.dart';
import '../models/user.dart';
import '../services/auth_services.dart';
import '../services/profile_service.dart';


class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  User? _user;
  Profile? _profile;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if user is already logged in
      final bool isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _user = await _authService.getCurrentUser();
        if (_user != null) {
          _profile = await _profileService.getCurrentProfile();
        }
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String firstName = '',
    String lastName = '',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authResponse = await _authService.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      _user = User(
        id: authResponse.userId,
        username: authResponse.username,
        email: authResponse.email,
        firstName: authResponse.firstName,
        lastName: authResponse.lastName,
      );

      _profile = await _profileService.getCurrentProfile();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Registration error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authResponse = await _authService.login(
        username: username,
        password: password,
      );

      _user = User(
        id: authResponse.userId,
        username: authResponse.username,
        email: authResponse.email,
        firstName: authResponse.firstName,
        lastName: authResponse.lastName,
      );

      _profile = await _profileService.getCurrentProfile();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Login error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      _profile = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProfile() async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _profileService.getCurrentProfile();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error refreshing profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String bio,
    required String location,
  }) async {
    if (_profile == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProfile = Profile(
        id: _profile!.id,
        userId: _profile!.userId,
        username: _profile!.username,
        email: _profile!.email,
        profilePicture: _profile!.profilePicture,
        bio: bio,
        location: location,
        dateJoined: _profile!.dateJoined,
      );

      _profile = await _profileService.updateProfile(updatedProfile);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Update profile error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}