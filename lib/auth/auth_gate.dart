import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../views/login_screen.dart';
import '../views/main_home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(

      // Listen to the authentication state changes

      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Build the UI based on the authentication state
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            )
          );
        }

        // Check if there is a valid session currently active
        final session = snapshot.data?.session ?? Supabase.instance.client.auth.currentSession;
        if (session != null) {
          // User is authenticated, navigate to the main home screen
          return const MainHomeScreen();
        }

        // User is not authenticated, navigate to the authentication screen
        return const LoginScreen();
      },
    );
  }
}