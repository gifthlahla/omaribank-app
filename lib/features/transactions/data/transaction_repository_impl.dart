import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:omari_bank_app/features/transactions/domain/transaction_model.dart';
import 'transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseClient _supabase;
  
  TransactionRepositoryImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Stream<List<TransactionModel>> watchUserTransactions(String userId) {
    return _supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data
            .where((tx) => tx['sender_id'] == userId || tx['recipient_id'] == userId)
            .map((json) => TransactionModel.fromJson(json))
            .toList());
  }

  @override
  Future<TransactionModel> getTransactionById(String transactionId) async {
    final response = await _supabase
        .from('transactions')
        .select()
        .eq('id', transactionId)
        .single();
    return TransactionModel.fromJson(response);
  }
}
