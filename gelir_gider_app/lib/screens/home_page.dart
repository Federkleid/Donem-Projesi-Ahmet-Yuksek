import 'package:flutter/material.dart';
import 'package:gelir_gider_app/screens/profile_screen.dart';
import 'package:gelir_gider_app/widgets/transaction_drag_sheet.dart';
import 'package:gelir_gider_app/utils/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home_page';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> transactions = [];
  DateTime _selectedMonth = DateTime.now();

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

  List<Map<String, dynamic>> _getTransactionsForSelectedMonth() {
    return transactions.where((transaction) {
      final transactionDate = DateFormat(
        'dd/MM/yyyy',
      ).parse(transaction['date']);
      return transactionDate.month == _selectedMonth.month &&
          transactionDate.year == _selectedMonth.year;
    }).toList();
  }

  Future<void> _deleteTransaction(int monthlyIndex) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> transactionStrings =
          prefs.getStringList('transactions') ?? [];

      // Aylık işlemler listesinden seçili işlemi alalım
      final monthlyTransactions = _getTransactionsForSelectedMonth();
      if (monthlyIndex < 0 || monthlyIndex >= monthlyTransactions.length) {
        return; // Geçersiz indeks kontrolü
      }

      final selectedTransaction = monthlyTransactions[monthlyIndex];

      // Global transactions listesinde bu işlemi bulalım
      int globalIndex = -1;
      for (int i = 0; i < transactions.length; i++) {
        // İşlemi benzersiz şekilde tanımlayan özellikleri karşılaştır
        if (transactions[i]['title'] == selectedTransaction['title'] &&
            transactions[i]['amount'] == selectedTransaction['amount'] &&
            transactions[i]['date'] == selectedTransaction['date'] &&
            transactions[i]['category'] == selectedTransaction['category']) {
          globalIndex = i;
          break;
        }
      }

      // Eğer global listede bulunursa silelim
      if (globalIndex >= 0 && globalIndex < transactions.length) {
        setState(() {
          transactions.removeAt(globalIndex);
        });

        if (globalIndex < transactionStrings.length) {
          transactionStrings.removeAt(globalIndex);
          await prefs.setStringList('transactions', transactionStrings);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşlem silinirken bir hata oluştu: $e')),
      );
    }
  }

  double _calculateTotalIncome() {
    return _getTransactionsForSelectedMonth()
        .where((transaction) => !transaction['isExpense'])
        .fold(
          0.0,
          (sum, transaction) => sum + (transaction['amount'] as num).toDouble(),
        );
  }

  double _calculateTotalExpense() {
    return _getTransactionsForSelectedMonth()
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
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider.isDarkMode;
    final monthlyTransactions = _getTransactionsForSelectedMonth();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          icon: Icon(Icons.account_circle_rounded, size: 36),
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: const Text("Ana Sayfa"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 36,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
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
                      onPressed: () {
                        setState(() {
                          _selectedMonth = DateTime(
                            _selectedMonth.year,
                            _selectedMonth.month - 1,
                          );
                        });
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedMonth),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedMonth = DateTime(
                            _selectedMonth.year,
                            _selectedMonth.month + 1,
                          );
                        });
                      },
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
                monthlyTransactions.isEmpty
                    ? Center(child: Text('Henüz işlem yok'))
                    : ListView.builder(
                      padding: EdgeInsets.only(bottom: 70),
                      itemCount: monthlyTransactions.length,
                      itemBuilder: (ctx, index) {
                        final transaction = monthlyTransactions[index];
                        return Dismissible(
                          key: Key('${index}_${transaction['title']}'),
                          direction:
                              DismissDirection
                                  .endToStart, // Sadece sağdan sola kaydırma
                          confirmDismiss: (direction) async {
                            // Silme onayı için dialog göster
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("İşlemi Sil"),
                                  content: Text(
                                    "'${transaction['title']}' işlemini silmek istediğinize emin misiniz?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text("İptal"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        "Sil",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            // İşlemi sil ve bildirim göster
                            _deleteTransaction(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('İşlem silindi')),
                            );
                          },
                          background: Container(), // Sol taraf boş
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
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
    );
  }
}
