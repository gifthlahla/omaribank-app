enum TransactionType { deposit, withdrawal, transfer }

class TransactionModel {
  final String id;
  final String? senderId;
  final String? recipientId;
  final double amount;
  final TransactionType type;
  final String status;
  final String? description;
  final String reference;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    this.senderId,
    this.recipientId,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    required this.reference,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      senderId: json['sender_id'],
      recipientId: json['recipient_id'],
      amount: (json['amount'] as num).toDouble(),
      type: _parseType(json['transaction_type']),
      status: json['status'] ?? 'completed',
      description: json['description'],
      reference: json['reference'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static TransactionType _parseType(String? type) {
    switch (type) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.transfer;
    }
  }

  bool get isIncoming => type == TransactionType.deposit || type == TransactionType.transfer; // Wait, need userId to check transfer direction, but we handle it via senderId/recipientId in the widget usually
  
  bool isOutgoing(String userId) {
    if (type == TransactionType.withdrawal) return true;
    if (type == TransactionType.transfer && senderId == userId) return true;
    return false;
  }
  
  bool isIncomingFor(String userId) {
    if (type == TransactionType.deposit) return true;
    if (type == TransactionType.transfer && recipientId == userId) return true;
    return false;
  }

  String displayTitle(String userId) {
    switch (type) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.transfer:
        return senderId == userId ? 'Sent Money' : 'Received Money';
    }
  }
}
