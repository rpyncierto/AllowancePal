import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 2; // Index of the selected tab

  List<String> tabNames = ['Analytics', 'Accounts', 'Transactions'];
  List<Account> accounts = [];

  String accountName = '';
  double balance = 0.0;
  String accountType = '';

  @override
  void initState() {
    super.initState();
    _fetchAccountData();
  }

  Future<void> _fetchAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountData = prefs.getString('accounts');

    if (accountData != null) {
      List<dynamic> accountList = json.decode(accountData);
      setState(() {
        accounts = accountList.map((item) => Account.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountData = json.encode(accounts);
    await prefs.setString('accounts', accountData);
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
                      Text(
                        'BALANCE',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        '\$${totalBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
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
                            child: Text(
                              '\$${spendableAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Selected Tab: ${tabNames[_selectedIndex]}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_selectedIndex == 1) ...[
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
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
                                style: TextStyle(
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
                ),
              ],
              if (_selectedIndex == 2) ...[
                const SizedBox(height: 16.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        8.0,
                      ), // Adjust the padding value as needed
                      // child: ListView.builder(
                      //   itemCount: transactions.length,
                      //   itemBuilder: (context, index) {
                      //     return Card(
                      //       elevation: 2.0,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //       ),
                      //       child: ListTile(
                      //         title: Text(
                      //           transactions[index].type,
                      //           style: TextStyle(
                      //             fontSize: 18.0,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         subtitle: Text(
                      //           'Amount: \$${transactions[index].amount.toStringAsFixed(2)}',
                      //           style: TextStyle(
                      //             fontSize: 16.0,
                      //             color: Colors.grey[600],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
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
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                _showAddAccountDialog();
              },
              child: Icon(Icons.add),
            )
          : _selectedIndex == 2
              ? FloatingActionButton(
                  onPressed: () {
                    _showAddTransactionDialog();
                  },
                  child: Icon(Icons.add),
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
        title: Text('Add Account'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Account Name'),
                  onChanged: (value) {
                    setState(() {
                      accountName = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Balance'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      balance = double.parse(value);
                    });
                  },
                ),
                SizedBox(height: 25.0),
                Text(
                  'Account Type:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  title: Text('Spendable'),
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
                  title: Text('Savings'),
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
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Add'),
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
    String transactionDescription = '';
    String? selectedAccount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Transaction'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Transaction Type'),
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Account'),
                  value: selectedAccount,
                  onChanged: (value) {
                    setState(() {
                      selectedAccount = value;
                    });
                  },
                  items:
                      accounts.map<DropdownMenuItem<String>>((Account account) {
                    return DropdownMenuItem<String>(
                      value: account.name,
                      child: Text(account.name),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
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
              

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Account {
  final String name;
  final double balance;
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
