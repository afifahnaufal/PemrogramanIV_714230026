import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late SharedPreferences loginData;
  String username = "";

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      // ✅ AMAN: ambil username remember me,
      // kalau tidak ada ambil temp_username
      username =
          loginData.getString('username') ??
          loginData.getString('temp_username') ??
          '';
    });
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              const Text('Welcome to Home'),
              const SizedBox(height: 20),

              // ✅ TETAP MUNCUL NAMA, TIDAK ADA "null"
              Text(username),

              ElevatedButton(
                onPressed: () async {
                  // ===== REMEMBER ME =====
                  bool rememberMe = loginData.getBool('remember_me') ?? false;

                  loginData.setBool('login', true);

                  // Hapus username hanya jika Remember Me TIDAK aktif
                  if (!rememberMe) {
                    loginData.remove('username');
                  }

                  // Username sementara selalu dihapus saat logout
                  loginData.remove('temp_username');

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
