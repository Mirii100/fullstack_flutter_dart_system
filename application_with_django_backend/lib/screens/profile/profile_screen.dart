import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers.dart';
import '../../services/profile_service.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.profile != null) {
      _bioController.text = authProvider.profile!.bio;
      _locationController.text = authProvider.profile!.location;
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile(
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
    );
    if (success && _profileImage != null && authProvider.profile != null) {
      final profileService = ProfileService();
      await profileService.uploadProfilePicture(authProvider.profile!.id, _profileImage!);
      await authProvider.refreshProfile();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Profile updated' : authProvider.error ?? 'Failed to update')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : authProvider.profile == null
          ? const Center(child: Text('Profile not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : authProvider.profile!.fullProfilePictureUrl.isNotEmpty
                  ? NetworkImage(authProvider.profile!.fullProfilePictureUrl)
                  : null,
              child: authProvider.profile!.fullProfilePictureUrl.isEmpty && _profileImage == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Change Profile Picture'),
            ),
            const SizedBox(height: 16),
            Text(
              authProvider.profile!.username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              authProvider.profile!.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}