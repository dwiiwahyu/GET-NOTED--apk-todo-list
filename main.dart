import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'todo_home_page.dart';  // Pastikan ini sesuai dengan path file kamu

void main() async {
  // Pastikan binding sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi semua locale agar DateFormat bisa pakai 'id', 'en', dsb
  await initializeDateFormatting();

  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key}); // Menggunakan Key jika diperlukan

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

// Halaman pertama saat aplikasi dibuka
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Background putih
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const WelcomeContent(),
          ),
        ),
      ),
    );
  }
}

// Konten utama di tengah
class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        WelcomeImage(),
        SizedBox(height: 5),
        StartText(),
        SizedBox(height: 65),
        LetsGoButton(),  // Tombol navigasi
      ],
    );
  }
}

// Widget gambar logo
class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      height: 260,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logogetnoted.png'),  // Ganti dengan path yang sesuai
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Teks motivasi
class StartText extends StatelessWidget {
  const StartText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Start organizing your day \nlike a pro!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
    );
  }
}

// Tombol LET’S GO yang sudah navigasi
class LetsGoButton extends StatelessWidget {
  const LetsGoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          // Navigasi ke halaman berikutnya (TodoHomePage)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TodoHomePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCB5CFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
        ),
        child: const Text(
          'LET’S GO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
