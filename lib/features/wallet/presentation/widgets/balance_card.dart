import 'package:flutter/material.dart';
import 'package:omari_bank_app/core/utils/formatters.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/features/wallet/domain/wallet_model.dart';
import 'skeleton_balance_card.dart';

class BalanceCard extends StatelessWidget {
  final WalletModel? wallet;
  final bool isLoading;

  const BalanceCard({
    super.key,
    required this.wallet,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || wallet == null) return const SkeletonBalanceCard();
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            AppStrings.availableBalance,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            AppFormatters.formatCurrency(wallet!.balance),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
