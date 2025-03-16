import 'package:flutter/material.dart';
import 'package:gelir_gider_app/widgets/transaction_drag_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home_page';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = true;
  static int ekgelir = 0;
  static int gelir = 14000;
  static int gider = 7500;

  static int totalbakiye = gelir + ekgelir;
  final int bakiye = totalbakiye - gider;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
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
      themeMode:
          _isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
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
              onPressed: _toggleDarkMode,
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
                      //tarihi geri alma
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
                            '$bakiye ₺',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: bakiye >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Aylık Bakiye',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
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
                                  SizedBox(height: 5),
                                  Text(
                                    '$totalbakiye ₺',
                                    style: TextStyle(
                                      fontSize: 20,
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
                                  SizedBox(height: 5),
                                  Text(
                                    '$gider ₺',
                                    style: TextStyle(
                                      fontSize: 20,
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
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (ctx, index) {
                  return Dismissible(
                    key: Key(index.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Veri Silindi.')));
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),

                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.green,
                        ),
                        title: Text('Maaş'),
                        subtitle: Text('Kategori - 13.03.2025'),
                        trailing: Text('+ $gelir ₺',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w700),),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            showAddTransactionSheet(context);
          },
          label: Text('Ekle', style: TextStyle(fontSize: 18)),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}
