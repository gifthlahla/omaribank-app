import 'package:flutter/material.dart';
import 'package:omari_bank_app/core/widgets/loading_shimmer.dart';

class SkeletonTransactionTile extends StatelessWidget {
  const SkeletonTransactionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: LoadingShimmer(
        child: ShimmerBox(width: 48, height: 48, borderRadius: 24),
      ),
      title: LoadingShimmer(
        child: ShimmerBox(width: 120, height: 16),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: LoadingShimmer(
          child: ShimmerBox(width: 180, height: 12),
        ),
      ),
      trailing: LoadingShimmer(
        child: ShimmerBox(width: 80, height: 16),
      ),
    );
  }
}
