import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/model_siswa.dart';
import 'detail_siswa.dart';

class SiswaScreen extends StatefulWidget {
  @override
  _SiswaScreenState createState() => _SiswaScreenState();
}

class _SiswaScreenState extends State<SiswaScreen> {
  List<Datum> tb_siswa = [];

  @override
  void initState() {
    super.initState();
    fetchPegawai();
  }

  Future<void> fetchPegawai() async {
    try {
      final response =
      await http.get(Uri.parse('http://192.168.100.128/latihan_delete/getSiswa.php'));
      if (response.statusCode == 200) {
        final List<Datum> parsedSiswa =
            modelSiswaFromJson(response.body).data;
        setState(() {
          tb_siswa = parsedSiswa;
        });
      } else {
        _showErrorSnackBar('Failed to load siswa');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load siswa: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }



  void editPegawaiDialog(Datum tb_siswa) {
    final TextEditingController firstnameController =
    TextEditingController(text: tb_siswa.firstname);
    final TextEditingController lastnameController =
    TextEditingController(text: tb_siswa.lastname);
    final TextEditingController phonenumberController =
    TextEditingController(text: tb_siswa.phonenumber);
    final TextEditingController emailController =
    TextEditingController(text: tb_siswa.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Siswa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstnameController,
                decoration: InputDecoration(hintText: 'First Name'),
              ),
              TextField(
                controller: lastnameController,
                decoration: InputDecoration(hintText: 'Last Name'),
              ),
              TextField(
                controller: phonenumberController,
                decoration: InputDecoration(hintText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                final firstname = firstnameController.text;
                final lastname = lastnameController.text;
                final phonenumber = phonenumberController.text;
                final email = emailController.text;

                if (firstname.isEmpty ||
                    lastname.isEmpty ||
                    phonenumber.isEmpty ||
                    email.isEmpty) {
                  _showErrorSnackBar('All fields are required');
                  return;
                }

                try {
                  final response = await http.put(
                    Uri.parse(
                        'http://192.168.100.128/latihan_delete/editSiswa.php?id=${tb_siswa.id}'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'firstname': firstname,
                      'lastname': lastname,
                      'phonenumber': phonenumber,
                      'email': email,
                    }),
                  );

                  if (response.statusCode == 200) {
                    fetchPegawai(); // Refresh pegawai list after editing
                    Navigator.pop(context);
                  } else {
                    _showErrorSnackBar('Failed to edit siswa');
                  }
                } catch (e) {
                  _showErrorSnackBar('Failed to edit siswa: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deleteSiswaDialog(Datum tb_siswa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Siswa'),
          content: Text('Are you sure you want to delete this siswa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final response = await http.delete(
                    Uri.parse(
                        'http://192.168.100.128/latihan_delete/deleteSiswa.php?id=${tb_siswa.id}'),
                  );

                  if (response.statusCode == 200) {
                    var responseData = json.decode(response.body);
                    if (responseData['is_success']) {
                      fetchPegawai(); // Refresh pegawai list after deleting
                      Navigator.pop(context);
                    } else {
                      _showErrorSnackBar(responseData['message']);
                    }
                  } else {
                    _showErrorSnackBar('Failed to delete siswa');
                  }
                } catch (e) {
                  _showErrorSnackBar('Failed to delete siswa: $e');
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showDetailScreen(Datum tb_siswa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSiswaScreen(tb_siswa: tb_siswa),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Siswa',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey, // Warna background app bar
      ),
      body: ListView.builder(
        itemCount: tb_siswa.length,
        itemBuilder: (context, index) {
          final siswaItem = tb_siswa[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading:
              Icon(Icons.person, size: 40, color: Colors.grey), // Icon pegawai
              title: Text('${siswaItem.firstname} ${siswaItem.lastname}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Phone: ${siswaItem.phonenumber}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Email: ${siswaItem.email}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black),
                    onPressed: () => editPegawaiDialog(siswaItem),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteSiswaDialog(siswaItem),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                    onPressed: () => showDetailScreen(siswaItem),
                  ),
                ],
              ),
            ),
          );
        },
      ),

    );
  }
}