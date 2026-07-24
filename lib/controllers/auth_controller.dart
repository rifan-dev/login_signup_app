import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      debugPrint('Login error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      rethrow;
    }
  }

  Future<void> signup({required String email, required String password}) async {
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      debugPrint('Signup error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Unexpected signup error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } on AuthException catch (e) {
      debugPrint('Logout error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Unexpected logout error: $e');
      rethrow;
    }
  }
}
