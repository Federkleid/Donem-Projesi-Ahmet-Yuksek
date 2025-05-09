import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash_screen';
  final String routesName;

  const SplashScreen({super.key, required this.routesName});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  String userName = '';
  
  // Ana logo animasyonu için controller
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  
  // Parçacık animasyonları için controller
  late AnimationController _particlesController;
  
  // Yükleme çubuğu animasyonu için controller
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    
    // Logo animasyonu için controller
    _scaleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );
    
    // Parçacık animasyonu için controller
    _particlesController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    // Yükleme çubuğu animasyonu
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 3400),
      vsync: this,
    );
    
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Tüm animasyonları başlat
    _scaleController.forward();
    _particlesController.repeat();
    _loadingController.forward();
    
    // Yönlendirme zamanlaması
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, widget.routesName);
    });
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '';
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particlesController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A237E),  // Koyu indigo
              Color(0xFF4527A0),  // Koyu mor
              Color(0xFF311B92),  // Derin mor
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Animasyonlu arka plan parçacıkları
            AnimatedBuilder(
              animation: _particlesController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlesPainter(
                    animation: _particlesController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
            
            // Dalgalı arka plan deseni
            Positioned.fill(
              child: CustomPaint(
                painter: WavePainter(),
              ),
            ),
            
            // Ana içerik
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animasyonu
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF3949AB).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.business_center,
                          size: 80,
                          color: Color(0xFF3949AB),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Yükleniyor göstergesi
                  AnimatedBuilder(
                    animation: _loadingAnimation,
                    builder: (context, child) {
                      return Column(
                        children: [
                          SizedBox(
                            width: size.width * 0.7,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _loadingAnimation.value,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF9C27B0),
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            '${(_loadingAnimation.value * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Karşılama metni animasyonu
                  FadeTransition(
                    opacity: _loadingAnimation,
                    child: Column(
                      children: [
                        Text(
                          userName.isNotEmpty ? 'Hoş Geldiniz $userName' : 'Hoş Geldiniz',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        const Text(
                          'Gelir/Gider yönetim sisteminize bağlanıyor...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Alt bilgi
            const Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Güvenli Bağlantı Sağlandı',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '© 2025 Royal Yazılım | Tüm Hakları Saklıdır',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dalga deseni için özel çizim
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Dalgalı çizgiyi oluştur
    path.moveTo(0, size.height * 0.7);
    
    // Birinci dalga
    path.quadraticBezierTo(
      size.width * 0.25, 
      size.height * 0.6, 
      size.width * 0.5, 
      size.height * 0.7
    );
    
    // İkinci dalga
    path.quadraticBezierTo(
      size.width * 0.75, 
      size.height * 0.8, 
      size.width, 
      size.height * 0.7
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    
    canvas.drawPath(path, paint);
    
    // İkinci dalga katmanı (daha yukarıda)
    final path2 = Path();
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    
    path2.moveTo(0, size.height * 0.8);
    
    path2.quadraticBezierTo(
      size.width * 0.2, 
      size.height * 0.9, 
      size.width * 0.5, 
      size.height * 0.8
    );
    
    path2.quadraticBezierTo(
      size.width * 0.8, 
      size.height * 0.7, 
      size.width, 
      size.height * 0.8
    );
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Parçacık animasyonu için özel çizim
class ParticlesPainter extends CustomPainter {
  final double animation;
  
  ParticlesPainter({required this.animation});
  
  @override
  void paint(Canvas canvas, Size size) {
    final particleCount = 30;
    final random = math.Random(42); // Sabit tohum değeri ile tutarlı rastgelelik
    
    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 1;
      
      // Animasyon değerine göre parçacık konumunu değiştir
      final offset = 20.0;
      final dx = math.sin((animation * 2 * math.pi) + i) * offset;
      final dy = math.cos((animation * 2 * math.pi) + i * 0.5) * offset;
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(random.nextDouble() * 0.3 + 0.1)
        ..style = PaintingStyle.fill;
        
      canvas.drawCircle(Offset(x + dx, y + dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}