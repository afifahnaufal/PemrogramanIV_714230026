import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class AdvancedForm extends StatefulWidget {
  const AdvancedForm({super.key});

  @override
  State<AdvancedForm> createState() => _AdvancedFormState();
}

class _AdvancedFormState extends State<AdvancedForm> {
  DateTime _dueDate = DateTime.now();
  final currentDate = DateTime.now();
  Color _currentColor = Colors.orange;
  String? _dataFile;
  File? _imageFile;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = result.files.first;
    if (file.extension == 'jpg' ||
        file.extension == 'png' ||
        file.extension == 'jpeg') {
      setState(() {
        _imageFile = File(file.path!); // Mengambil file gambar
      });
    }
    //Memanggil setState untuk memperbarui tampilan UI
    setState(() {
      //Memperbarui nilai _dataFile dengan nama file yang dipilih
      _dataFile = file.name;
    });
    _openFile(file);
  }

  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Widget'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildDatePicker(context),
            const SizedBox(height: 20),
            buildColorPicker(context),
            const SizedBox(height: 20),
            buildFilePicker(context),
            // buildDatePicker,
            // buildColorPicker,
            // buildFilePicker,
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Date'),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                final selectDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(1990),
                  lastDate: DateTime(currentDate.year + 5),
                );
                setState(() {
                  if (selectDate != null) {
                    _dueDate = selectDate;
                  }
                });
              },
            ), // TextButton
          ],
        ), // Row
        Text(DateFormat('dd-MM-yyyy').format(_dueDate)),
      ],
    ); // Column
  }

  Widget buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color'),
        const SizedBox(height: 10),
        Container(
          height: 100,
          width: double.infinity,
          color: _currentColor,
        ), // Container
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _currentColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Pick Your Color'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorPicker(
                          pickerColor: _currentColor,
                          onColorChanged: (color) {
                            setState(() {
                              _currentColor = color;
                            });
                          },
                        ), // BlockPicker
                      ],
                    ), // Column
                    actions: [
                      TextButton(
                        onPressed: () {
                          return Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ), // TextButton
                    ],
                  ); // AlertDialog
                },
              );
            },
            child: const Text('Pick Color'),
          ), // ElevatedButton
        ), // Center
      ],
    ); // Column
  }

  Widget buildFilePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick File'),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _pickFile();
            },
            child: const Text('Pick and Open File'),
          ), // ElevatedButton
        ), // Center
        if (_dataFile != null) Text('File Name: $_dataFile'),
        const SizedBox(height: 10),
        // Menampilkan gambar jika ada
        if (_imageFile != null)
          Image.file(
            _imageFile!,
            height: 200, // Ukuran gambar
            width: double.infinity,
            fit: BoxFit.cover, // Menyesuaikan gambar
          ), // Image.file
      ],
    ); // Column
  }
}
