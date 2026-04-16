import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:omari_bank_app/features/transactions/domain/transaction_model.dart';
import 'package:omari_bank_app/features/transactions/data/transaction_repository.dart';
import 'package:omari_bank_app/features/transactions/data/transaction_repository_impl.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(supabase: Supabase.instance.client);
});

final transactionsProvider = StreamProvider.family<List<TransactionModel>, String>((ref, userId) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchUserTransactions(userId);
});
