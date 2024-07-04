import 'package:flutter/material.dart';
import '../model/model_siswa.dart';

class DetailSiswaScreen extends StatelessWidget {
  final Datum tb_siswa;

  DetailSiswaScreen({required this.tb_siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Siswa'),
        centerTitle: true,
        backgroundColor: Colors.grey, // Ubah warna background AppBar menjadi biru
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 100, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              '${tb_siswa.firstname} ${tb_siswa.lastname}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Phone:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              '${tb_siswa.phonenumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              '${tb_siswa.email}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}