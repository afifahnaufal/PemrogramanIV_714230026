import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';

class Contact {
  String name;
  String phone;
  String date;
  Color color;
  String? filePath;

  Contact({
    required this.name,
    required this.phone,
    required this.date,
    required this.color,
    this.filePath,
  });
}

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController dateC = TextEditingController();

  Color selectedColor = const Color(0xFF00C853); // default green
  String? pickedFile;

  List<Contact> contacts = [];

  // Edit mode
  bool isEditMode = false;
  int? editingIndex;

  // VALIDATION RULES
  String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return "Phone Number harus diisi";
    if (!RegExp(r"^\d+$").hasMatch(v)) return "Hanya angka";
    if (!v.startsWith("62")) return "Harus diawali 62";
    if (v.length < 8 || v.length > 13) return "8–13 digit";
    return null;
  }

  String? validateName(String? v) {
    if (v == null || v.isEmpty) return "Nama harus diisi";
    final words = v.trim().split(RegExp(r"\s+"));
    if (words.length < 2) return "Minimal 2 kata";
    for (var w in words) {
      if (!RegExp(r"^[A-Z][a-zA-Z]+$").hasMatch(w)) {
        return "Setiap kata harus kapital & tanpa angka";
      }
    }
    return null;
  }

  Future pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) setState(() => pickedFile = result.files.single.path);
  }

  void _clearFormFields() {
    phoneC.clear();
    nameC.clear();
    dateC.clear();
    pickedFile = null;
    selectedColor = const Color(0xFF00C853);
    setState(() {});
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    final newContact = Contact(
      name: nameC.text.trim(),
      phone: phoneC.text.trim(),
      date: dateC.text.trim(),
      color: selectedColor,
      filePath: pickedFile,
    );

    if (isEditMode && editingIndex != null) {
      setState(() {
        contacts[editingIndex!] = newContact;
        isEditMode = false;
        editingIndex = null;
      });
      _clearFormFields();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kontak diupdate')));
      return;
    }

    setState(() {
      contacts.add(newContact);
    });

    _clearFormFields();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Kontak ditambahkan')));
  }

  void startEdit(int index) {
    final c = contacts[index];
    setState(() {
      isEditMode = true;
      editingIndex = index;
      nameC.text = c.name;
      phoneC.text = c.phone;
      dateC.text = c.date;
      selectedColor = c.color;
      pickedFile = c.filePath;
    });

    // optionally you can scroll to top if using a ScrollController
  }

  void deleteContact(int index) {
    final name = contacts[index].name;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus kontak'),
        content: Text('Yakin ingin menghapus "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                contacts.removeAt(index);
                if (isEditMode && editingIndex == index) {
                  isEditMode = false;
                  editingIndex = null;
                  _clearFormFields();
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Kontak "$name" dihapus')));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void deleteAll() {
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tidak ada kontak')));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus semua kontak'),
        content: const Text('Yakin ingin menghapus semua kontak?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                contacts.clear();
                isEditMode = false;
                editingIndex = null;
                _clearFormFields();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua kontak dihapus')),
              );
            },
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }

  // === Color Picker dialog that matches the example style ===
  void showElegantColorPickerDialog() {
    Color tempColor = selectedColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Rounded dialog like example
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Pick Your Color',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Picker area (big square)
                SizedBox(
                  width: 320,
                  height: 260,
                  child: ColorPicker(
                    pickerColor: tempColor,
                    onColorChanged: (c) {
                      tempColor = c;
                      // update live preview inside dialog by calling setState of dialog
                      // use StatefulBuilder to update dialog UI
                    },
                    // Use the block/picker area style similar to screenshot (HSV square + hue)
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    paletteType: PaletteType.hsvWithHue,
                    labelTypes: const [],
                    // show some additional sliders by setting portrait/horizontal params (we'll show a hue slider manually below)
                  ),
                ),

                const SizedBox(height: 12),

                // Live preview + RGB values (we'll use StatefulBuilder to reflect changes)
                StatefulBuilder(
                  builder: (context, setStateDialog) {
                    // Recreate a color picker but wire onColorChanged to update both tempColor and setStateDialog
                    return Column(
                      children: [
                        // small preview circle
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: tempColor,
                            ),
                            const SizedBox(width: 12),
                            // RGB text
                            Expanded(
                              child: Text(
                                'R ${(tempColor.r * 255.0).round()}  G ${(tempColor.g * 255.0).round()}  B ${(tempColor.b * 255.0).round()}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Hue slider (from the color picker package)
                        SizedBox(
                          height: 28,
                          child: SliderTheme(
                            data: SliderTheme.of(
                              context,
                            ).copyWith(trackHeight: 10),
                            child: ColorPicker(
                              pickerColor: tempColor,
                              onColorChanged: (c) {
                                tempColor = c;
                                setStateDialog(() {}); // update preview & RGB
                              },
                              enableAlpha: false,
                              displayThumbColor: true,
                              pickerAreaHeightPercent:
                                  0.0, // hide square area here, only use slider
                              paletteType: PaletteType.hsvWithHue,
                              labelTypes: const [],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => selectedColor = tempColor);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // A better dialog implementation: use StatefulBuilder properly to update the color live.
  void showElegantColorPicker() {
    Color tempColor = selectedColor;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Pick Your Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The main square picker:
                    SizedBox(
                      width: 320,
                      height: 240,
                      child: ColorPicker(
                        pickerColor: tempColor,
                        onColorChanged: (c) {
                          tempColor = c;
                          setStateDialog(() {}); // update dialog preview & rgb
                        },
                        pickerAreaHeightPercent: 0.7,
                        enableAlpha: false,
                        displayThumbColor: true,
                        paletteType: PaletteType.hsvWithHue,
                        labelTypes: const [],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Preview row with circle and RGB
                    Row(
                      children: [
                        CircleAvatar(radius: 18, backgroundColor: tempColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'R ${(tempColor.r * 255.0).round()}   G ${(tempColor.g * 255.0).round()}   B ${(tempColor.b * 255.0).round()}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => selectedColor = tempColor);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: phoneC,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              validator: validatePhone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameC,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dateC,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final p = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2100),
                    );
                    if (p != null) {
                      dateC.text = DateFormat('dd-MM-yyyy').format(p);
                    }
                  },
                ),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Tanggal harus diisi' : null,
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Color:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 80,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
            ),

            ElevatedButton(
              onPressed: showElegantColorPicker,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
              ),
              child: Text(
                isEditMode ? 'Change Color' : 'Pick Color',
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pick Files',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FC3F7),
                    ),
                    child: const Text(
                      'Pick and Open File',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (pickedFile != null)
                  IconButton(
                    onPressed: () {
                      if (pickedFile != null &&
                          (pickedFile!.endsWith('.png') ||
                              pickedFile!.endsWith('.jpg') ||
                              pickedFile!.endsWith('.jpeg'))) {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              Dialog(child: Image.file(File(pickedFile!))),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preview tidak tersedia untuk file ini',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: submit,
                    icon: Icon(isEditMode ? Icons.save : Icons.add),
                    label: Text(isEditMode ? 'Update Contact' : 'Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00ACC1),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (isEditMode)
                  OutlinedButton(
                    onPressed: () {
                      _clearFormFields();
                      setState(() {
                        isEditMode = false;
                        editingIndex = null;
                      });
                    },
                    child: const Text('Batal'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactTile(Contact c, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => startEdit(index),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: c.color,
          backgroundImage: c.filePath != null && File(c.filePath!).existsSync()
              ? FileImage(File(c.filePath!))
              : null,
          child: c.filePath == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        title: Text(
          c.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.phone),
            const SizedBox(height: 4),
            Text(
              c.date,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            // decorative progress-like bar (mirip gambar)
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.6,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => startEdit(index),
              icon: const Icon(Icons.edit, color: Colors.orange),
              tooltip: 'Edit',
            ),
            IconButton(
              onPressed: () => deleteContact(index),
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneC.dispose();
    nameC.dispose();
    dateC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        title: const Text('UTS', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: deleteAll,
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Hapus Semua',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            buildFormCard(),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text(
                  'List Contact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Total: ${contacts.length}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 12),
            contacts.isEmpty
                ? Column(
                    children: const [
                      SizedBox(height: 30),
                      Icon(Icons.contact_page, size: 72, color: Colors.black12),
                      SizedBox(height: 8),
                      Text('Belum ada kontak. Isi form lalu Submit.'),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contacts.length,
                    itemBuilder: (_, i) => buildContactTile(contacts[i], i),
                  ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00BCD4),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contact List',
          ),
        ],
        currentIndex: 1,
        onTap: (idx) {
          if (idx == 0) Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
