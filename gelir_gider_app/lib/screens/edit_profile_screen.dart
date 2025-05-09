import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gelir_gider_app/utils/theme_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text =
          prefs.getString('user_email') ?? 'kullanici@email.com';
    });
  }

  Future<void> _saveUserData() async {
    // E-posta doğrulama
    if (!_isEmailValid(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir e-posta adresi girin'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('user_email', _emailController.text.trim());

    Navigator.pop(
      context,
      true,
    ); // ProfileScreen'e geri dön ve güncellendiğini bildir
  }

  // Basit e-posta kontrolü
  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider.isDarkMode;
    final accentColor = const Color(0xFFFF7643);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesap Bilgilerini Düzenle"),
        backgroundColor: accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Bilgileri Başlığı
            Text(
              "Profil Bilgileriniz",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Kullanıcı Adı Alanı
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Kullanıcı Adı",
                prefixIcon: Icon(Icons.person, color: accentColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accentColor, width: 2),
                ),
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),

            const SizedBox(height: 20),

            // E-posta Alanı
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-posta Adresi",
                prefixIcon: Icon(Icons.email, color: accentColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accentColor, width: 2),
                ),
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
                hintText: "ornek@email.com",
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),

            const SizedBox(height: 30),

            // Kaydet Butonu
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Değişiklikleri Kaydet"),
              onPressed: _saveUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
