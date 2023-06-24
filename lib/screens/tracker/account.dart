class Account {
  final String name;
  double balance;
  final String type;

  Account(this.name, this.balance, this.type);

  Account.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        balance = json['balance'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'balance': balance,
        'type': type,
      };
}
