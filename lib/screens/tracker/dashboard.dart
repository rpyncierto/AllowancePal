import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 2; // Index of the selected tab

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
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
