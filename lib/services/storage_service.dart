import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadProfilePhoto(String userId, String filePath) async {
    try {
      final file = File(filePath);
      final fileExt = filePath.split('.').last;
      final fileName = '$userId/profile.$fileExt';
      await _client.storage.from('profilephotos').upload(fileName, file, fileOptions: const FileOptions(upsert: true));
      final url = _client.storage.from('profilephotos').getPublicUrl(fileName);
      print('Uploaded profile photo URL: $url'); // Debugging
      return url;
    } catch (e) {
      print('Error uploading profile photo: $e');
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  Future<String> uploadXray(String patientId, String filePath) async {
    try {
      final file = File(filePath);
      final fileExt = filePath.split('.').last;
      final fileName = '$patientId/xray_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      await _client.storage.from('xrays').upload(fileName, file);
      final url = _client.storage.from('xrays').getPublicUrl(fileName);
      print('Uploaded X-ray URL: $url'); // Debugging
      return url;
    } catch (e) {
      print('Error uploading X-ray: $e');
      throw Exception('Failed to upload X-ray: $e');
    }
  }
}