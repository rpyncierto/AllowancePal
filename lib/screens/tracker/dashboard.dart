import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'BALANCE',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          '\$1,500',
                          style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 8.0),
                      AccountBreakdownCard(
                        account: 'Account 1',
                        currentBalance: '\$800',
                      ),
                      AccountBreakdownCard(
                        account: 'Account 2',
                        currentBalance: '\$500',
                      ),
                      AccountBreakdownCard(
                        account: 'Account 3',
                        currentBalance: '\$200',
                      ),
                      AccountBreakdownCard(
                        account: 'Account 4',
                        currentBalance: '\$300',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountBreakdownCard extends StatelessWidget {
  final String account;
  final String currentBalance;

  const AccountBreakdownCard({
    required this.account,
    required this.currentBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text(
          account,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          currentBalance,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
