import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:omari_bank_app/features/wallet/domain/wallet_model.dart';
import 'package:omari_bank_app/features/wallet/data/wallet_repository.dart';
import 'package:omari_bank_app/features/wallet/data/wallet_repository_impl.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(supabase: Supabase.instance.client);
});

final walletProvider = StreamProvider.family<WalletModel?, String>((ref, userId) {
  final repo = ref.watch(walletRepositoryProvider);
  return repo.watchUserWallet(userId);
});

class WalletController extends StateNotifier<AsyncValue<void>> {
  final WalletRepository _repository;

  WalletController(this._repository) : super(const AsyncValue.data(null));

  Future<void> deposit(double amount) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deposit(amount);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> withdraw(double amount) async {
    state = const AsyncValue.loading();
    try {
      await _repository.withdraw(amount);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<String?> transfer({
    required String recipientId,
    required double amount,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    try {
      final ref = await _repository.transfer(
        recipientId: recipientId,
        amount: amount,
        description: description,
      );
      state = const AsyncValue.data(null);
      return ref;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}

final walletControllerProvider = StateNotifierProvider<WalletController, AsyncValue<void>>((ref) {
  final repo = ref.watch(walletRepositoryProvider);
  return WalletController(repo);
});
