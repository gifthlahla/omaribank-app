import 'package:omari_bank_app/features/wallet/domain/wallet_model.dart';

abstract class WalletRepository {
  Stream<WalletModel?> watchUserWallet(String userId);
  Future<double> getBalance(String userId);
  Future<void> deposit(double amount);
  Future<void> withdraw(double amount);
  Future<String> transfer({
    required String recipientId,
    required double amount,
    String? description,
  });
}
