import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/core/utils/formatters.dart';
import 'package:omari_bank_app/core/utils/extensions.dart';
import 'package:omari_bank_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:omari_bank_app/features/transactions/domain/transaction_model.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final isOutgoing = transaction.isOutgoing(user.id);
    final color = isOutgoing ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transactionDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(isOutgoing),
                size: 48,
                color: color,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              '${isOutgoing ? '-' : '+'}${AppFormatters.formatCurrency(transaction.amount)}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              transaction.displayTitle(user.id),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.paddingXLarge),
            _buildDetailRow(
              context,
              'Status',
              transaction.status.toUpperCase(),
              valueColor: _getStatusColor(transaction.status),
            ),
            const Divider(height: 32),
            _buildDetailRow(
              context,
              'Date & Time',
              AppFormatters.formatDateTime(transaction.createdAt),
            ),
            const Divider(height: 32),
            _buildDetailRow(
              context,
              'Reference',
              transaction.reference,
              showCopy: true,
            ),
            if (transaction.description != null && transaction.description!.isNotEmpty) ...[
              const Divider(height: 32),
              _buildDetailRow(
                context,
                'Description',
                transaction.description!,
              ),
            ],
            if (transaction.type == TransactionType.transfer) ...[
              const Divider(height: 32),
              if (isOutgoing) 
                 _buildDetailRow(context, 'To (Recipient ID)', transaction.recipientId ?? 'Unknown')
              else
                 _buildDetailRow(context, 'From (Sender ID)', transaction.senderId ?? 'Unknown'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? valueColor, bool showCopy = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: valueColor,
                  ),
                ),
              ),
              if (showCopy) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    context.showSnackBar('Copied to clipboard');
                  },
                  child: const Icon(Icons.copy, size: 20),
                ),
              ]
            ],
          ),
        ),
      ],
    );
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'reversed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
