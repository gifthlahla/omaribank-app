import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/core/widgets/empty_state.dart';
import 'package:omari_bank_app/core/widgets/error_widget.dart';
import 'package:omari_bank_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:omari_bank_app/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:omari_bank_app/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:omari_bank_app/features/transactions/presentation/widgets/skeleton_transaction_tile.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final transactionsAsync = ref.watch(transactionsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.transactionHistory)),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(transactionsProvider(user.id)),
        child: transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return const CustomEmptyState(
                title: 'No Transactions',
                subtitle: 'You haven\'t made any transactions yet.',
                icon: Icons.receipt_long_outlined,
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: transactions.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                return TransactionTile(
                  transaction: transactions[index],
                  currentUserId: user.id,
                );
              },
            );
          },
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: 10,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (_, _) => const SkeletonTransactionTile(),
          ),
          error: (error, _) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.invalidate(transactionsProvider(user.id)),
          ),
        ),
      ),
    );
  }
}
