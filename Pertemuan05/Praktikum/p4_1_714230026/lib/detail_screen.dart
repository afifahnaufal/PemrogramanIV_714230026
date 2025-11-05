import 'package:flutter/material.dart';
import 'model/tourism_place.dart';

// class FavoriteButton extends StatefulWidget {
//   const FavoriteButton({super.key});

//   @override
//   State<FavoriteButton> createState() => _FavoriteButtonState();
// }

// class _FavoriteButtonState extends State<FavoriteButton> {
//   // Variabel state untuk menyimpan status favorit
//   bool isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     // IconButton yang akan memicu perubahan state ketika ditekan
//     return IconButton(
//       icon: Icon(
//         // Ganti ikon berdasarkan nilai isFavorite
//         isFavorite ? Icons.favorite : Icons.favorite_border,
//         color: Colors.red,
//         size: 30.0,
//       ),
//       onPressed: () {
//         // Panggil setState untuk membangun ulang widget dengan nilai baru
//         setState(() {
//           isFavorite = !isFavorite;
//         });
//         // Opsional: Tampilkan feedback
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               isFavorite ? 'Ditambahkan ke Favorit!' : 'Dihapus dari Favorit.',
//             ),
//             duration: const Duration(milliseconds: 500),
//           ),
//         );
//       },
//     );
//   }
// }

class DetailScreen extends StatelessWidget {
  final TourismPlace place;
  const DetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bungkus body dengan SingleChildScrollView agar konten bisa di-scroll
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio:  4/3,
                child: Image.asset(place.imageAsset,fit:BoxFit.cover)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color:Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),

            // 2. BAGIAN JUDUL LOKASI
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Text(
                place.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  // Sesuaikan dengan font yang Anda gunakan di project Anda
                  // atau tambahkan property fontFamily: 'Oxygen',
                ),
              ),
            ),

            // 3. BAGIAN INFO LOKASI (menggunakan Row dengan 3 Column)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Info Hari Buka
                  Column(
                    children: const <Widget>[
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(height: 8.0),
                      Text('Open Everyday', style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                  // Info Jam Buka
                  Column(
                    children: const <Widget>[
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(height: 8.0),
                      Text('09:00 - 20:00', style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                  // Info Harga Tiket
                  Column(
                    children: const <Widget>[
                      Icon(Icons.monetization_on, color: Colors.blue),
                      SizedBox(height: 8.0),
                      Text('Rp 17.500', style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
            ),

            // 4. BAGIAN DESKRIPSI (menggunakan Container dengan Padding)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                place.description,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16.0),
              ),
            ),

            // 5. BAGIAN GALLERY (Tambahan opsional agar layar lebih panjang/scrollable)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Galeri Foto',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: place.imageUrls.map((url) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 16/9,
                        child: Image.network(url,fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
