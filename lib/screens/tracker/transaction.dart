import 'account.dart';

class Transaction {
  final double amount;
  final String transactionType;
  final Account account;
  final String description;

  Transaction({
    required this.amount,
    required this.transactionType,
    required this.account,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      transactionType: json['transactionType'],
      account: Account.fromJson(json['account']),
      description: json['description'],
    );
  }
}
