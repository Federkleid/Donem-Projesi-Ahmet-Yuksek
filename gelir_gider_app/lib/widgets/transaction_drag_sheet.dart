import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

void showAddTransactionSheet(BuildContext context, Function refreshCallback) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController customCategoryController = TextEditingController();

  bool isExpense = true;
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  // "Diğer" kategorisini giderlere de ekledim
  final List<String> expenseCategories = ['Gıda', 'Kira', 'Eğlence', 'Diğer'];
  final List<String> incomeCategories = ['Maaş', 'Bonus', 'Diğer'];

  Future<void> saveTransaction(String title, double amount, String category, DateTime date, bool isExpense) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Daha önce kayıtlı işlemleri al
    List<String> transactions = prefs.getStringList('transactions') ?? [];

    // Yeni işlemi JSON formatında ekle
    final newTransaction = {
      'title': title,
      'amount': amount,
      'category': category,
      'date': DateFormat('dd/MM/yyyy').format(date),
      'isExpense': isExpense
    };

    transactions.add(jsonEncode(newTransaction));

    // Güncellenmiş listeyi kaydet
    await prefs.setStringList('transactions', transactions);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yeni İşlem Ekle',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text('Gider'),
                        selected: isExpense,
                        onSelected: (selected) {
                          setModalState(() {
                            isExpense = true;
                            selectedCategory = null;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: Text('Gelir'),
                        selected: !isExpense,
                        onSelected: (selected) {
                          setModalState(() {
                            isExpense = false;
                            selectedCategory = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Başlık',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Tutar (₺)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: Text('Kategori seçin'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setModalState(() {
                      selectedCategory = newValue;
                      // Diğer dışında bir kategori seçildiğinde, özel kategori alanını temizle
                      if (selectedCategory != 'Diğer') {
                        customCategoryController.clear();
                      }
                    });
                  },
                  items: (isExpense ? expenseCategories : incomeCategories)
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                if (selectedCategory == 'Diğer')
                  SizedBox(height: 16),
                if (selectedCategory == 'Diğer')
                  TextField(
                    controller: customCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Kendi kategorinizi yazın',
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Tarih: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setModalState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text('Tarih Seç'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Kullanıcının girdiği değerleri kaydet
                      if (titleController.text.isEmpty || amountController.text.isEmpty || selectedCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                        );
                        return;
                      }
                      
                      // Özel kategori kontrolü - Diğer seçildiğinde ve özel kategori girildiğinde
                      String finalCategory;
                      if (selectedCategory == 'Diğer') {
                        if (customCategoryController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lütfen özel kategori adı girin!')),
                          );
                          return;
                        }
                        finalCategory = customCategoryController.text;
                      } else {
                        finalCategory = selectedCategory!;
                      }

                      // Tutar formatını kontrol et
                      double amount;
                      try {
                        amount = double.parse(amountController.text.replaceAll(',', '.'));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lütfen geçerli bir tutar girin!')),
                        );
                        return;
                      }

                      await saveTransaction(
                        titleController.text,
                        amount,
                        finalCategory,
                        selectedDate,
                        isExpense,
                      );

                      Navigator.pop(context); // Modal'ı kapat
                      
                      // Ana sayfayı yenile
                      refreshCallback();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('İşlem başarıyla kaydedildi!')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Ekle'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          );
        },
      );
    },
  );
}