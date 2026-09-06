import 'package:flutter/foundation.dart';
import 'package:login_signup_app/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  AuthProvider(this.authService) {
    _loadUsername();
  }

  String? _currentUsername;
  bool _isLoading = true;

  String? get currentUsername => _currentUsername;
  bool get isLoading => _isLoading;

  Future<void> _loadUsername() async {
    _isLoading = true;
    notifyListeners();

    _currentUsername = await authService.getCurrentUsername();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshUsername() async {
    await _loadUsername();
  }
}