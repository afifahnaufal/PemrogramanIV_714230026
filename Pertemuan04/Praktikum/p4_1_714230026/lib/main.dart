import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempat Wisata Bandung',
      theme: ThemeData(),
      home: const DetailScreen(),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: const Text(
                'Ranca Upas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // kasih jarak merata antar kolom
                crossAxisAlignment:
                    CrossAxisAlignment.start, // sejajarkan dari atas
                children: <Widget>[
                  Column(
                    children: const <Widget>[
                      Icon(Icons.calendar_today),
                      SizedBox(height: 8.0),
                      Text('Open Everyday'),
                    ],
                  ),

                  Column(
                    children: const <Widget>[
                      Icon(Icons.access_time),
                      SizedBox(height: 8.0),
                      Text('09:00 - 20:00'),
                    ],
                  ),
                  Column(
                    children: const <Widget>[
                      Icon(Icons.monetization_on),
                      SizedBox(height: 8.0),
                      Text('Rp 17.500'),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Ranca Upas adalah sebuah kawasan wisata alam yang terletak di daerah Ciwidey, Bandung, Jawa Barat. Tempat ini terkenal dengan pemandian air panas alami, camping ground, dan penangkaran rusa yang menarik banyak wisatawan untuk berkunjung. Di Ranca Upas, pengunjung dapat menikmati keindahan alam pegunungan, berendam di kolam air panas, serta berinteraksi langsung dengan rusa-rusa yang jinak. Selain itu, terdapat juga fasilitas seperti area bermain anak, restoran, dan penginapan sederhana bagi yang ingin menginap lebih lama.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
