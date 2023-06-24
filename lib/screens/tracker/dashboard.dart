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
                        '\$1,500',
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
                              '\$2,000', // Replace with the actual expense limit value
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
                      LinearProgressIndicator(
                        value: 0.7, // Adjust the value as needed
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Account'),
        content: Column(
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
          ],
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
              accounts.add(Account(accountName, balance));
              await _saveAccountData(); // Save the updated account data
              _fetchAccountData(); // Fetch updated account data
              Navigator.pop(context);
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

  Account(this.name, this.balance);

  Account.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        balance = json['balance'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'balance': balance,
      };
}
