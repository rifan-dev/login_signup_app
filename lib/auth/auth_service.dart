import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  final supabase = Supabase.instance.client;

  // Sign up a new user with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final userId = response.user?.id;
      if (userId != null) {
        await supabase.from('profiles').insert({
          'id': userId,
          'username': username,
        });
      }
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('Username already exists');
      } else {
        throw Exception('Database error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Sign in an existing user with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut(scope: SignOutScope.global);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }

  
  

  // Get the current userEmail
  String? getCurrentUserEmail() {
    final session = _client.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<String?> getCurrentUsername() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final data =
          await _client
              .from('profiles')
              .select('username')
              .eq('id', userId)
              .single();
      String? username = data['username'] as String?;
      return username;
    } catch (e) {
      print('getCurrentUsername error: $e');
      return null;
    }
  }
}
