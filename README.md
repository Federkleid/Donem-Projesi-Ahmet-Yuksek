# Kişisel Gelir Gider Takip Uygulaması 📊

Bu uygulama, kişisel gelir ve gider işlemlerini takip etmenizi sağlayan kullanıcı dostu bir Flutter uygulamasıdır. Aylık gelir-gider durumunuzu görselleştirmenize ve finansal durumunuzu kolayca izlemenize olanak tanır.

## 📱 Özellikler

- 💰 Gelir ve gider işlemlerini kaydetme
- 📅 İşlemleri tarih ve kategorilere göre düzenleme
- 📊 Aylık gelir-gider özeti görüntüleme
- 🗑️ İşlemleri kaydırarak silme özelliği
- 🔄 Ay bazlı işlem filtreleme
- 🌓 Koyu/açık tema desteği
- 💾 Yerel depolama ile veri saklama

## 📸 Ekran Görüntüleri

![foto1](https://github.com/user-attachments/assets/19520741-0046-4f47-b259-dd64fd290ea5)
![foto2](https://github.com/user-attachments/assets/bdc54e2b-9d73-471b-b7eb-23cd0c004b4c)
![foto3](https://github.com/user-attachments/assets/c2f936a5-6b64-439f-9680-51082f83430e)


## 🛠️ Kullanılan Teknolojiler

- **Flutter**: UI geliştirme framework'ü
- **Dart**: Programlama dili
- **Shared Preferences**: Yerel veri depolama için
- **Intl**: Tarih ve para birimi formatlaması için

## 📦 Paket Bağımlılıkları

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0  # Yerel depolama için
  intl: ^0.18.0  # Tarih ve para birimi formatlaması için
```

## 🚀 Kurulum

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

1. Flutter SDK'yı bilgisayarınıza kurun. [Flutter kurulum kılavuzu](https://flutter.dev/docs/get-started/install)
2. Bu repository'yi klonlayın:
   ```
   git clone https://github.com/kullanici-adi/gelir_gider_app.git
   ```
3. Proje dizinine gidin:
   ```
   cd gelir_gider_app
   ```
4. Bağımlılıkları yükleyin:
   ```
   flutter pub get
   ```
5. Uygulamayı çalıştırın:
   ```
   flutter run
   ```

## 📁 Proje Yapısı

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── screens/
│   ├── home_page.dart           # Ana sayfa ekranı
│   └── splash_screen.dart       # Açılış ekranı
└── widgets/
    └── transaction_drag_sheet.dart  # İşlem ekleme formu
```

## 📝 Nasıl Kullanılır

1. Uygulama açıldığında, gelir ve giderlerinizin bir özetini ana ekranda göreceksiniz.
2. Yeni bir işlem eklemek için ekranın altındaki "Ekle" butonuna tıklayın.
3. İşlem tipini seçin (Gelir/Gider).
4. İşlem başlığı, tutarı ve kategorisini girin.
5. İsteğe bağlı olarak işlem tarihini seçin.
6. "Ekle" butonuna tıklayarak işlemi kaydedin.
7. İşlemleri silmek için listedeki bir işlemi sağdan sola kaydırın.
8. Aylık görünümü değiştirmek için ekranın üst kısmındaki ok simgelerini kullanın.

## 🔜 Gelecek Özellikler

- Grafik ve istatistik görünümleri
- Özelleştirilebilir kategoriler
- Tekrarlanan işlemler
- Bütçe planlama ve hatırlatmalar
- Veri yedekleme ve geri yükleme

## 🤝 Katkıda Bulunma

Katkıda bulunmak istiyorsanız:

1. Bu repository'yi fork edin.
2. Yeni bir feature branch oluşturun: `git checkout -b my-new-feature`
3. Değişikliklerinizi commit edin: `git commit -am 'Add some feature'`
4. Branch'inizi push edin: `git push origin my-new-feature`
5. Pull request gönderin.
