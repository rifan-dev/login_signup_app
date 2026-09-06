import 'package:flutter/material.dart';
import 'package:login_signup_app/auth/auth_service.dart';
import 'package:login_signup_app/provider/auth_provider.dart';
import 'package:login_signup_app/views/main_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/app_theme.dart';
import 'provider/auth_controller.dart';
import 'views/login_screen.dart';

const String supabaseUrl = 'https://aisrutgsajmpmqnwfzbx.supabase.co';
const String supabaseAnonKey = 'sb_publishable_-J61j6hKdriPqsBmX1ydTg_y_ijL8tG';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService()),
          child: const MyApp(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Signup App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return const MainHomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
