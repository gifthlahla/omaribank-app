import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/core/utils/extensions.dart';
import 'package:omari_bank_app/core/widgets/confirmation_dialog.dart';
import 'package:omari_bank_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:omari_bank_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:omari_bank_app/features/profile/presentation/widgets/settings_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: AppStrings.logout,
      content: AppStrings.confirmLogout,
      confirmText: AppStrings.logout,
      isDestructive: true,
    );

    if (confirm == true) {
      ref.read(authControllerProvider.notifier).signOut();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            ProfileHeader(user: user),
            const SizedBox(height: AppConstants.paddingXLarge),
            
            // Settings Group
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      context.showSnackBar('Edit profile coming soon');
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.security,
                    title: 'Security',
                    subtitle: 'Change password, biometric setup',
                    onTap: () {
                      context.showSnackBar('Security settings coming soon');
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    onTap: () {
                      context.showSnackBar('Notification settings coming soon');
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      context.showSnackBar('Help center coming soon');
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingXLarge),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleLogout(context, ref),
                icon: const Icon(Icons.logout),
                label: const Text(AppStrings.logout),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Omari Bank v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
