import 'package:flutter/material.dart';
import 'package:omari_bank_app/core/utils/formatters.dart';
import 'package:omari_bank_app/features/transactions/domain/transaction_model.dart';
import 'package:go_router/go_router.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final String currentUserId;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isOutgoing = transaction.isOutgoing(currentUserId);
    
    return ListTile(
      onTap: () => context.push('/transaction_detail', extra: transaction),
      leading: CircleAvatar(
        backgroundColor: _getBackgroundColor(isOutgoing).withValues(alpha: 0.1),
        child: Icon(_getIcon(isOutgoing), color: _getBackgroundColor(isOutgoing)),
      ),
      title: Text(
        transaction.displayTitle(currentUserId),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        AppFormatters.formatDateTime(transaction.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isOutgoing ? '-' : '+'}${AppFormatters.formatCurrency(transaction.amount)}',
            style: TextStyle(
              color: isOutgoing ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (transaction.status != 'completed')
            Text(
              transaction.status.toUpperCase(),
              style: TextStyle(
                color: Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(bool isOutgoing) {
    if (transaction.type == TransactionType.deposit) return Colors.green;
    if (transaction.type == TransactionType.withdrawal) return Colors.orange;
    return isOutgoing ? Colors.blue : Colors.purple;
  }

  IconData _getIcon(bool isOutgoing) {
    switch (transaction.type) {
      case TransactionType.deposit:
        return Icons.arrow_downward;
      case TransactionType.withdrawal:
        return Icons.arrow_upward;
      case TransactionType.transfer:
        return isOutgoing ? Icons.arrow_outward : Icons.arrow_downward;
    }
  }
}
