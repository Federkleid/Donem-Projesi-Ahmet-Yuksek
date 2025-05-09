import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gelir_gider_app/screens/edit_profile_screen.dart';
import 'package:gelir_gider_app/utils/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String userEmail = "";
  String? userProfileImage;
  int selectedAvatarIndex = 0;
  final ImagePicker _picker = ImagePicker();

  // Avatar görsel yolları
  final List<String> avatarAssets = [
    "images/profile.png",     // Varsayılan profil
    "images/man.png",         // Bay
    "images/woman.png",       // Bayan
    "images/boy.png",         // Erkek çocuk
    "images/girl.png",        // Kız çocuk
    "images/anonymous.png",   // Anonim
  ];

  // Avatar isim listesi (dialog içinde gösterilecek)
  final List<String> avatarNames = [
    "Varsayılan",
    "Bay",
    "Bayan",
    "Erkek Çocuk",
    "Kız Çocuk",
    "Anonim",
  ];

  // Platform kontrolü - Windows veya Web üzerinde miyiz?
  bool get _isWindowsOrWeb {
    return kIsWeb || Platform.isWindows;
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '';
      userEmail = prefs.getString('user_email') ?? 'kullanici@email.com';

      if (_isWindowsOrWeb) {
        selectedAvatarIndex = prefs.getInt('selected_avatar_index') ?? 0;
      } else {
        userProfileImage = prefs.getString('user_profile_image');
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          userProfileImage = pickedFile.path;
        });

        // Profil resmi yolunu kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_profile_image', pickedFile.path);
      }
    } catch (e) {
      // Hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilemedi: $e')),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photoFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (photoFile != null) {
        setState(() {
          userProfileImage = photoFile.path;
        });

        // Profil resmi yolunu kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_profile_image', photoFile.path);
      }
    } catch (e) {
      // Hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fotoğraf çekilemedi: $e')),
      );
    }
  }

  // Windows ve Web platformları için avatar seçimi
  Future<void> _saveSelectedAvatar(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_avatar_index', index);
    setState(() {
      selectedAvatarIndex = index;
    });
  }

  void _showImageSourceOptions() {
    if (_isWindowsOrWeb) {
      // Windows & Web için avatar seçim diyaloğu göster
      _showAvatarSelectionDialog();
    } else {
      // Mobil platformlar için normal seçenekleri göster
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Profil Fotoğrafı Seç',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Galeriden Seç',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage();
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: 'Fotoğraf Çek',
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Avatar seçim opsiyonu ekle
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showAvatarSelectionDialog();
                },
                icon: Icon(Icons.face),
                label: Text('Hazır Avatar Seç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7643),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Avatar seçim diyaloğu
  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Avatar Seçin',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: avatarAssets.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _saveSelectedAvatar(index);
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedAvatarIndex == index
                                  ? const Color(0xFFFF7643)
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              avatarAssets[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          avatarNames[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selectedAvatarIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Color(0xFFFF7643), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7643),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider.isDarkMode;
    final backgroundColor = isDarkMode ? Color(0xFF121212) : Colors.grey[50];
    final textColor = isDarkMode ? Colors.white : Color(0xFF303030);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Profil",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7643), Color(0xFFFF9865)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _isWindowsOrWeb
                      ? ProfilePicWindows(
                          avatarPath: avatarAssets[selectedAvatarIndex],
                          onImageTap: _showImageSourceOptions,
                        )
                      : ProfilePic(
                          imagePath: userProfileImage,
                          onImageTap: _showImageSourceOptions,
                        ),
                  const SizedBox(height: 15),
                  Text(
                    userName.isNotEmpty ? userName : "Kullanıcı Adı Yok",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem("Medya", "1"),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildStatItem("Arkadaşlar", "540"),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildStatItem("Beğeniler", "982"),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Column(
                  children: [
                    _buildMenuCategory("Hesap", isDarkMode),
                    ProfileMenu(
                      text: "Hesap Bilgilerim",
                      icon: Icons.person,
                      press: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                        if (result == true) {
                          _loadUserData();
                        }
                      },
                    ),

                    const Divider(height: 1),
                    ProfileMenu(
                      text: "Bildirimler",
                      icon: Icons.notifications,
                      press: () {},
                      showBadge: true,
                    ),
                    const Divider(height: 1),
                    ProfileMenu(
                      text: "Gizlilik Ayarları",
                      icon: Icons.security,
                      press: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Column(
                  children: [
                    _buildMenuCategory("Destek", isDarkMode),
                    ProfileMenu(
                      text: "Yardım Merkezi",
                      icon: Icons.help_outline,
                      press: () {},
                    ),
                    const Divider(height: 1),
                    ProfileMenu(
                      text: "Hakkında",
                      icon: Icons.info_outline,
                      press: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFFF7643),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () {},
                label: const Text(
                  "Çıkış Yap",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.logout, size: 20),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCategory(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Color(0xFF8B8B8B),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Mobil platformlar için profil resmi widget'ı
class ProfilePic extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onImageTap;

  const ProfilePic({Key? key, this.imagePath, required this.onImageTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 115,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child:
                imagePath != null && File(imagePath!).existsSync()
                    ? Image.file(File(imagePath!), fit: BoxFit.cover)
                    : Image.asset("images/profile.png", fit: BoxFit.cover),
          ),
          Positioned(
            right: -5,
            bottom: 0,
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7643),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onImageTap,
                icon: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Windows platformu için profil resmi widget'ı
class ProfilePicWindows extends StatelessWidget {
  final String avatarPath;
  final VoidCallback onImageTap;

  const ProfilePicWindows({
    Key? key,
    required this.avatarPath,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 115,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: Image.asset(
              avatarPath,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: -5,
            bottom: 0,
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7643),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onImageTap,
                icon: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.showBadge = false,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final bool showBadge;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeProvider.of(context).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Color(0xFF303030);

    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFFF7643), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            if (showBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7643),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "3",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white70 : Color(0xFF8B8B8B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}