import 'account.dart';
class Transaction {
  double amount;
  String transactionType;
  Account account;
  String description;

  Transaction({
    required this.amount,
    required this.transactionType,
    required this.account,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'transactionType': transactionType,
      'account': account.toJson(),
      'description': description,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      transactionType: json['transactionType'],
      account: Account.fromJson(json['account']),
      description: json['description'],
    );
  }
}
