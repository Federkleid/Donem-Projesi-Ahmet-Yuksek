import 'package:flutter/material.dart';
import 'package:gelir_gider_app/widgets/transaction_drag_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home_page';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = true;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transactionStrings = prefs.getStringList('transactions') ?? [];
    setState(() {
      transactions =
          transactionStrings
              .map((item) => jsonDecode(item) as Map<String, dynamic>)
              .toList();
    });
  }

  Future<void> _deleteTransaction(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transactionStrings = prefs.getStringList('transactions') ?? [];

    if (index >= 0 && index < transactionStrings.length) {
      setState(() {
        transactionStrings.removeAt(index);
        transactions.removeAt(index);
      });
      await prefs.setStringList('transactions', transactionStrings);
    }
  }

  double _calculateTotalIncome() {
    return transactions
        .where((transaction) => !transaction['isExpense'])
        .fold(
          0.0,
          (sum, transaction) => sum + (transaction['amount'] as num).toDouble(),
        );
  }

  double _calculateTotalExpense() {
    return transactions
        .where((transaction) => transaction['isExpense'])
        .fold(
          0.0,
          (sum, transaction) => sum + (transaction['amount'] as num).toDouble(),
        );
  }

  double _calculateBalance() {
    return _calculateTotalIncome() - _calculateTotalExpense();
  }

  void _refreshTransactions() {
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        dividerColor: Colors.white10,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle_rounded, size: 36),
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          title: const Text("Ana Sayfa"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                size: 36,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
          titleTextStyle: TextStyle(fontSize: 28),
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => (),
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        'Mart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '${_calculateBalance().toStringAsFixed(2)} ₺',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color:
                                  _calculateBalance() >= 0
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Kalan Bakiye',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Gelir',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${_calculateTotalIncome().toStringAsFixed(2)} ₺',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Gider',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${_calculateTotalExpense().toStringAsFixed(2)} ₺',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  transactions.isEmpty
                      ? Center(child: Text('Henüz işlem yok'))
                      : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (ctx, index) {
                          final transaction = transactions[index];
                          return Dismissible(
                            key: Key('${index}_${transaction['title']}'),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _deleteTransaction(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('İşlem silindi')),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 6,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(
                                    transaction['isExpense']
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                  backgroundColor:
                                      transaction['isExpense']
                                          ? Colors.red
                                          : Colors.green,
                                ),
                                title: Text(transaction['title']),
                                subtitle: Text(
                                  '${transaction['category']} - ${transaction['date']}',
                                ),
                                trailing: Text(
                                  '${transaction['isExpense'] ? "-" : "+"} ${transaction['amount']} ₺',
                                  style: TextStyle(
                                    color:
                                        transaction['isExpense']
                                            ? Colors.red
                                            : Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showAddTransactionSheet(context, _refreshTransactions);
          },
          label: Text('Ekle', style: TextStyle(fontSize: 18)),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}
