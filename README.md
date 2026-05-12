# Student Stress Predictor — Mobile App

Aplikasi mobile Flutter untuk memprediksi tingkat stres mahasiswa berbasis AI. Transformasi dari sistem web ke mobile app dengan fokus pada UI/UX modern, clean, dan calming — mirip wellness/health tracker.

## 🎨 Design System

| Token | Warna | Kegunaan |
|-------|-------|----------|
| Primary | `#4F39F6` | Tombol, header, aksen |
| Background | `#F8F9FE` | Latar halaman |
| Stress Rendah | `#83C400` | Hijau (skor rendah) |
| Stress Sedang | `#EEAA2A` | Kuning/orange (skor sedang) |
| Stress Tinggi | `#F14E4E` | Merah (skor tinggi) |

**Font**: Open Sans (Google Fonts)

## 📱 Fitur

- **Login & Register** — Autentikasi dengan email, password, NIM
- **Lupa Password** — Reset password via email
- **Dashboard** — Greeting, statistik, insight, riwayat terbaru
- **Kuesioner** — 20 pertanyaan (skala 1-5) di 4 kategori: Akademik, Fisik, Psikologis, Sosial
- **Hasil Prediksi** — Warna & emoji adaptif berdasarkan level stres (Rendah/Sedang/Tinggi)
- **Detail Prediksi** — Breakdown per kategori dengan progress bar, rekomendasi
- **Riwayat** — Seluruh prediksi sebelumnya dengan filter statistik
- **Notifikasi** — Reminder kuesioner, jadwal konsultasi
- **Profil** — Info user, statistik akun, logout
- **Floating Bottom Navigation** — Rounded modern navbar

## 🏗️ Arsitektur

```
lib/
├── main.dart                          # Entry point + MultiProvider
├── app/
│   ├── app.dart                       # MaterialApp + GoRouter
│   └── routes.dart                    # Route constants
├── core/
│   ├── theme/                         # Colors, TextStyles, ThemeData
│   └── widgets/                       # Reusable components
├── features/
│   ├── auth/                          # Login, Register, Forgot Password
│   ├── dashboard/                     # Home screen
│   ├── questionnaire/                 # Kuesioner + questions
│   ├── result/                        # Hasil prediksi + detail
│   ├── history/                       # Riwayat prediksi
│   ├── notification/                  # Notifikasi
│   └── profile/                       # Profil user
└── navigation/
    └── bottom_nav_shell.dart          # Floating bottom nav
```

**State Management**: Provider  
**Routing**: GoRouter  
**Animasi**: flutter_animate  
**Icons**: iconsax_flutter

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK ^3.7.2
- Dart SDK
- Android Studio / VS Code
- Emulator Android atau device fisik

### Langkah

```bash
# 1. Clone repository
git clone https://github.com/RAVEEIZZ/student-stress-app_mobile.git
cd student-stress-app_mobile

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run

# 4. Atau build APK
flutter build apk
```

### Login Mock
Saat ini aplikasi menggunakan **mock data** — masukkan email dan password apapun untuk login.

## 📦 Dependencies

| Package | Versi | Kegunaan |
|---------|-------|----------|
| provider | ^6.1.2 | State management |
| go_router | ^14.8.1 | Routing & navigation |
| google_fonts | ^6.2.1 | Font Open Sans |
| flutter_animate | ^4.5.2 | Micro-animations |
| percent_indicator | ^4.2.3 | Progress bar breakdown |
| iconsax_flutter | ^1.0.0+1 | Ikon modern outline |

## 🔌 Integrasi API (Coming Soon)

Aplikasi sudah dirancang **REST API ready**. Untuk integrasi:

1. Buat service layer di `lib/core/services/`
2. Ganti mock data di setiap Provider dengan HTTP call
3. Endpoint yang dibutuhkan:
   - `POST /auth/login`
   - `POST /auth/register`
   - `POST /auth/forgot-password`
   - `GET /predictions` (riwayat)
   - `POST /predictions` (submit kuesioner)
   - `GET /predictions/:id` (detail)
   - `GET /notifications`
   - `GET /profile`

## 📋 Alur Penggunaan

1. **Login/Register** → Masuk atau buat akun baru
2. **Dashboard** → Lihat statistik dan insight
3. **Kuesioner** → Tap tombol "Mulai Prediksi" atau tab Kuesioner
4. **Isi Kuesioner** → Jawab 20 pertanyaan (skala 1-5)
5. **Hasil** → Lihat level stres, score, confidence
6. **Detail** → Lihat breakdown kategori + rekomendasi
7. **Riwayat** → Pantau perkembangan stres dari waktu ke waktu

## 📄 License

MIT License
