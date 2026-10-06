import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        print('Sign-in failed: No user returned');
        return null;
      }
      final userData = await _client
          .from('users')
          .select('id, email, role, name, profile_photo_url')
          .eq('id', response.user!.id)
          .single();
      print('Signed in user: ${userData['id']}, role: ${userData['role']}, name: ${userData['name']}'); // Enhanced logging
      return UserModel.fromJson(userData);
    } catch (e) {
      print('Sign-in error: $e');
      rethrow;
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String role,
    required String name,
    String? profilePhotoPath,
    DateTime? birthDate,
    String? specialty,
  }) async {
    try {
      if (role == 'doctor' && profilePhotoPath == null) {
        throw Exception('Profile photo is mandatory for doctors');
      }
      if (role == 'doctor' && (specialty == null || specialty.isEmpty)) {
        throw Exception('Specialty is mandatory for doctors');
      }
      if (role == 'patient' && birthDate == null) {
        throw Exception('Birth date is mandatory for patients');
      }
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final userId = response.user!.id;
      print('Signed up user ID: $userId'); // Debugging

      final profilePhotoUrl = profilePhotoPath != null
          ? await StorageService().uploadProfilePhoto(userId, profilePhotoPath)
          : null;

      final userData = await _client.from('users').insert({
        'id': userId,
        'email': email,
        'role': role,
        'name': name,
        'profile_photo_url': profilePhotoUrl,
      }).select().single();
      print('Inserted user: ${userData['id']}, role: ${userData['role']}, name: ${userData['name']}, profile_photo_url: $profilePhotoUrl'); // Enhanced logging

      if (role == 'doctor') {
        await _client.from('doctors').insert({
          'id': userId,
          'specialty': specialty,
          'average_rating': 0,
          'rating_count': 0,
        });
        print('Inserted doctor record for ID: $userId, specialty: $specialty'); // Debugging
      } else if (role == 'patient') {
        await _client.from('patients').insert({
          'id': userId,
          'birth_date': birthDate!.toIso8601String(),
        });
        print('Inserted patient record for ID: $userId, birth_date: ${birthDate.toIso8601String()}'); // Debugging
      }

      return UserModel.fromJson(userData);
    } catch (e) {
      print('Sign-up error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  UserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.id,
      email: user.email!,
      role: '', // This needs to be fetched from the database
      name: '',
      profilePhotoUrl: null,
    );
  }
}