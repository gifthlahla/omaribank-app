import 'package:flutter/material.dart';
import 'package:omari_bank_app/core/widgets/loading_shimmer.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';

class SkeletonBalanceCard extends StatelessWidget {
  const SkeletonBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Column(
        children: [
          const LoadingShimmer(
            child: ShimmerBox(width: 120, height: 16),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          const LoadingShimmer(
            child: ShimmerBox(width: 180, height: 40),
          ),
        ],
      ),
    );
  }
}
