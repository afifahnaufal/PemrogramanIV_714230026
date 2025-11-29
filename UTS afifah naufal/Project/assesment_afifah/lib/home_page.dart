import 'package:flutter/material.dart';
import 'list_contact_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Pemrograman IV'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.indigo.shade100,
                      child: const Icon(Icons.person, size: 38),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'NPM: 714230025',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Nama: Afifah Naufal Rahmani',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Kelas: 3A - D4 Teknik Informatika',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ContactListPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.contacts),
                      label: const Text('List Contacts'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instruksi singkat:\nTekan tombol List Contacts untuk membuka layar yang mengandung form input (Phone Number, Name, Date, Color, File) dan daftar kontak.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
