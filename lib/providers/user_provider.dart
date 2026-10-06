import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();

  UserModel? get user => _user;

  Future<void> setUser(UserModel? user) async {
    _user = user;
    if (_user != null) {
      // Fetch full user data including role from database
      try {
        final userData = await _authService.signIn(_user!.email, ''); // Use a dummy password; we already have the session
        _user = userData;
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
    notifyListeners();
  }

  void updateProfilePhoto(String profilePhotoUrl) {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        email: _user!.email,
        role: _user!.role,
        name: _user!.name,
        profilePhotoUrl: profilePhotoUrl,
      );
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}