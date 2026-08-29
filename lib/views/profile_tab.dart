import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = AuthService();

    final currentEmail = authService.getCurrentUserEmail();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'User Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (currentEmail != null) ...[
            const SizedBox(height: 8),
            Text(
              currentEmail,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              await authService.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          )
        ],
      ),
    );
  }
}
