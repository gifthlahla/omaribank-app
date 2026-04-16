import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';

class QuickActionItem {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  QuickActionItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickActionItem(
        icon: Icons.send_rounded,
        label: AppStrings.sendMoney,
        route: '/send',
        color: Theme.of(context).primaryColor,
      ),
      QuickActionItem(
        icon: Icons.account_balance_wallet_rounded,
        label: AppStrings.depositMoney,
        route: '/deposit',
        color: Theme.of(context).colorScheme.secondary,
      ),
      QuickActionItem(
        icon: Icons.money_off_rounded,
        label: AppStrings.withdrawMoney,
        route: '/withdraw',
        color: Colors.orange,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) => _buildActionCard(context, action)).toList(),
    );
  }

  Widget _buildActionCard(BuildContext context, QuickActionItem action) {
    return InkWell(
      onTap: () => context.push(action.route),
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                action.icon,
                color: action.color,
                size: 28,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              action.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
