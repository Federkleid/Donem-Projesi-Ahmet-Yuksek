import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showAddTransactionSheet(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isExpense = true;
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  final List<String> expenseCategories = ['Gıda', 'Kira', 'Eğlence'];
  final List<String> incomeCategories = ['Maaş', 'Bonus', 'Diğer'];

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
                    onPressed: () {
                      Navigator.pop(context);
                      print('İşlem Eklendi');
                      print(titleController.text,);
                      print(selectedCategory,);
                      print(selectedDate);
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
