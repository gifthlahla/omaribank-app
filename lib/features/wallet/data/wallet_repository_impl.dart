import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:omari_bank_app/features/wallet/domain/wallet_model.dart';
import 'wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final SupabaseClient _supabase;
  
  WalletRepositoryImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Stream<WalletModel?> watchUserWallet(String userId) {
    return _supabase
        .from('wallets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.isNotEmpty ? WalletModel.fromJson(data.first) : null);
  }

  @override
  Future<double> getBalance(String userId) async {
    final response = await _supabase
        .from('wallets')
        .select('balance')
        .eq('user_id', userId)
        .single();
    return (response['balance'] as num).toDouble();
  }

  @override
  Future<void> deposit(double amount) async {
    await _supabase.rpc('process_deposit', params: {
      'p_amount': amount,
      'p_payment_method': 'mobile_app',
    });
  }

  @override
  Future<void> withdraw(double amount) async {
    await _supabase.rpc('process_withdrawal', params: {
      'p_amount': amount,
      'p_payment_method': 'mobile_app',
    });
  }

  @override
  Future<String> transfer({
    required String recipientId,
    required double amount,
    String? description,
  }) async {
    final result = await _supabase.rpc('transfer_money', params: {
      'p_recipient_id': recipientId,
      'p_amount': amount,
      'p_description': description,
    });
    return result as String;
  }
}
