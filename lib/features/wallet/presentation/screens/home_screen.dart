import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:omari_bank_app/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:omari_bank_app/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:omari_bank_app/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:omari_bank_app/features/transactions/presentation/widgets/skeleton_transaction_tile.dart';
import 'package:omari_bank_app/features/wallet/presentation/widgets/balance_card.dart';
import 'package:omari_bank_app/features/wallet/presentation/widgets/quick_actions_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    
    // Watch wallet and transactions if user is authenticated
    final walletAsyncValue = user != null 
        ? ref.watch(walletProvider(user.id)) 
        : const AsyncValue.loading();
        
    final transactionsAsyncValue = user != null 
        ? ref.watch(transactionsProvider(user.id)) 
        : const AsyncValue.loading();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (user != null) {
            ref.invalidate(walletProvider(user.id));
            ref.invalidate(transactionsProvider(user.id));
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hello, ${user?.fullName ?? 'User'}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Balance Card
              walletAsyncValue.when(
                data: (wallet) => BalanceCard(wallet: wallet),
                loading: () => const BalanceCard(wallet: null, isLoading: true),
                error: (error, _) => const BalanceCard(wallet: null),
              ),
              
              const SizedBox(height: AppConstants.paddingLarge),
              
              const QuickActionsGrid(),
              
              const SizedBox(height: AppConstants.paddingLarge),
              
              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.recentTransactions,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/transactions'),
                    child: const Text(AppStrings.viewAll),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingSmall),
              
              // Transactions List (Max 5)
              transactionsAsyncValue.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No transactions yet.'),
                      ),
                    );
                  }
                  
                  final recentTransactions = transactions.take(5).toList();
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        transaction: recentTransactions[index],
                        currentUserId: user?.id ?? '',
                      );
                    },
                  );
                },
                loading: () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (_, _) => const SkeletonTransactionTile(),
                ),
                error: (error, _) => Center(child: Text('Error loading transactions')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
