import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'account.dart';
import 'transaction.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0; // Index of the selected tab

  List<String> tabNames = ['Accounts', 'Transactions'];
  List<Account> accounts = [];
  List<Account> spendableAccounts = []; // List to hold spendable accounts
  List<Transaction> transactions = [];

  String accountName = '';
  double balance = 0.0;
  String accountType = '';
  double inflow = 0.0;
  double outflow = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAccountData();
    _fetchTransactionData();
  }

  Future<void> _fetchAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountData = prefs.getString('accounts');

    if (accountData != null) {
      List<dynamic> accountList = json.decode(accountData);
      setState(() {
        accounts = accountList.map((item) => Account.fromJson(item)).toList();
        spendableAccounts = accounts.where((account) => account.type == 'Spendable').toList();
      });
    }
  }

  Future<void> _fetchTransactionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionData = prefs.getString('transactions');

    if (transactionData != null) {
      List<dynamic> transactionList = json.decode(transactionData);
      setState(() {
        transactions = transactionList
            .map((item) => Transaction.fromJson(item as Map<String, dynamic>)
                as Transaction)
            .toList();
        inflow = 0.0;
        outflow = 0.0;

        for (var transaction in transactions) {
        if (transaction.transactionType == "Income") {
          inflow += transaction.amount;
        } else {
          outflow += transaction.amount;
        }
      }
      });
    }
  }

  Future<void> _saveAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountData = json.encode(accounts);
    await prefs.setString('accounts', accountData);
  }

  Future<void> _saveTransactionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionData = json.encode(transactions);
    await prefs.setString('transactions', transactionData);
  }

  @override
  Widget build(BuildContext context) {
    double totalBalance = 0.0;
    for (var account in accounts) {
      totalBalance += account.balance;
    }

    double spendableAmount = 0.0;
    for (var account in accounts) {
      if (account.type == 'Spendable') {
        spendableAmount += (account.balance * 0.7);
      }
    }

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'TOTAL BALANCE',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          '\$${totalBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Spendable',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\$${spendableAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Inflow',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '\$${inflow.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Outflow',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '\$${outflow.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              if (_selectedIndex == 0) ...[
                const SizedBox(height: 16.0),
                Text(
                  'Accounts:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0), // Adjust the padding value as needed
                    child: ListView.builder(
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              accounts[index].name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Balance: \$${accounts[index].balance.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteAccount(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
              if (_selectedIndex == 1) ...[
                const SizedBox(height: 16.0),
                Text(
                  'Transactions:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0), // Adjust the padding value as needed
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              transactions[index].description,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Amount: \$${transactions[index].amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteTransaction(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.analytics),
          //   label: 'Analytics',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _showAddAccountDialog();
              },
              child: const Icon(Icons.add),
            )
          : _selectedIndex == 1
              ? FloatingActionButton(
                  onPressed: () {
                    _showAddTransactionDialog();
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }

  void _deleteAccount(int index) async {
    setState(() {
      accounts.removeAt(index);
    });
    await _saveAccountData(); // Save the updated account data
    _fetchAccountData(); // Fetch updated account data
  }

  void _deleteTransaction(int index) async {
    setState(() {
      transactions.removeAt(index);
    });
    await _saveTransactionData(); // Save the updated transaction data
    _fetchTransactionData(); // Fetch updated transaction data
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddAccountDialog() {
    // Define variables to hold the selected value
    String? selectedAccountType;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Account'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Account Name'),
                  onChanged: (value) {
                    setState(() {
                      accountName = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Balance'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      balance = double.parse(value);
                    });
                  },
                ),
                const SizedBox(height: 25.0),
                const Text(
                  'Account Type:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  title: const Text('Spendable'),
                  leading: Radio<String>(
                    value: 'Spendable',
                    groupValue: selectedAccountType,
                    onChanged: (value) {
                      setState(() {
                        selectedAccountType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Savings'),
                  leading: Radio<String>(
                    value: 'Savings',
                    groupValue: selectedAccountType,
                    onChanged: (value) {
                      setState(() {
                        selectedAccountType = value;
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () async {
              if (selectedAccountType != null) {
                accounts
                    .add(Account(accountName, balance, selectedAccountType!));
                await _saveAccountData(); // Save the updated account data
                _fetchAccountData(); // Fetch updated account data
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog() {
    // Define variables to hold the transaction details
    String? transactionType;
    double transactionAmount = 0.0;
    Account? selectedAccount;
    String transactionDescription = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Transaction'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Transaction Type'),
                  value: transactionType,
                  onChanged: (value) {
                    setState(() {
                      transactionType = value;
                    });
                  },
                  items: <String>[
                    'Income',
                    'Expense',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<Account>(
                  decoration: const InputDecoration(labelText: 'Account'),
                  value: selectedAccount,
                  onChanged: (value) {
                    setState(() {
                      selectedAccount = value;
                    });
                  },
                  items: accounts
                      .map<DropdownMenuItem<Account>>((Account account) {
                    return DropdownMenuItem<Account>(
                      value: account,
                      child: Text(account.name),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      transactionAmount = double.parse(value);
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    setState(() {
                      transactionDescription = value;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (transactionType != null && selectedAccount != null) {
                // Update the account balance based on the transaction type, amount, and description
                if (transactionType == 'Income') {
                  selectedAccount!.balance += transactionAmount;
                } else if (transactionType == 'Expense') {
                  selectedAccount!.balance -= transactionAmount;
                }

                transactions.add(Transaction(
                    amount: transactionAmount,
                    transactionType: transactionType!,
                    account: selectedAccount!,
                    description: transactionDescription));

                // Save the updated account and transaction data
                _saveAccountData();
                _saveTransactionData();

                // Fetch the updated account and transaction data
                _fetchAccountData();
                _fetchTransactionData();

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
