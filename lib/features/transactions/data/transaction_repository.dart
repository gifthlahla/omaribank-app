import 'package:omari_bank_app/features/transactions/domain/transaction_model.dart';

abstract class TransactionRepository {
  Stream<List<TransactionModel>> watchUserTransactions(String userId);
  Future<TransactionModel> getTransactionById(String transactionId);
}
