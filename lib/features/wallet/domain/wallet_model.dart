class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      userId: json['user_id'],
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
