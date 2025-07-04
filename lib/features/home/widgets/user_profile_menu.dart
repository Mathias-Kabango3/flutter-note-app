import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/service_providers.dart';

class UserProfileMenu extends ConsumerWidget {
  const UserProfileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProfileProvider);

    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          ref.read(authServiceProvider).signOut();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: userProfile.when(
            data: (profile) => Text(
              profile?.displayName ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            loading: () => const Text('Loading...'),
            error: (_, __) => const Text('Error'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.logout, color: AppColors.error),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
      child: const CircleAvatar(
        backgroundColor: AppColors.accent,
        child: Icon(Icons.person, color: AppColors.primary),
      ),
    );
  }
}
