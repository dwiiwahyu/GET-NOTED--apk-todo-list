import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget { // menerima daftar kategori dan callback
  final List<Map<String, dynamic>> categories; // daftar kategori yg diteirma dari parent
  final Function(List<Map<String, dynamic>>) onCategoryUpdated; // fungsi callback u memperbarui kategori

  const CategoryPage({
    Key? key,
    required this.categories, // konstruktor u menginisialisasi kategori
    required this.onCategoryUpdated, // konstruktor untuk menginisialisasi kategori fungsi oncategoryupdate
  }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState(); // mmebuat state u widget ini
}

class _CategoryPageState extends State<CategoryPage> {
  late List<Map<String, dynamic>> localCategories; // daftar lokal untuk menyimpan kategori yang dimodifikasi

  @override
  void initState() {
    super.initState();
    localCategories = List.from(widget.categories); // menginisialisasi localcategories dengan data dari parent
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent, // mengatur warna latar belakang halaman
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20), // menambahkan jarak diatas judul
            const Text(
              'Categories', // kategori
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20), // jarak bawah judul
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE9E9E9), // warna BG kontainer
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // border
                ),
                child: ListView.builder( // membuat kategori yang dapat digulir
                  itemCount: localCategories.length, // jumlah kategori yg ada
                  itemBuilder: (context, index) {
                    final category = localCategories[index]; // mendapatkan data kategori pada index saat ini
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: category['color'],
                        ),
                        title: Text(category['name']), 
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit), // ikon edit
                              onPressed: () => _showEditCategoryDialog(category, index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteCategory(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: _showAddCategoryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickColor((color) {
                  selectedColor = color;
                }),
                child: const Text('Pick Color'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  localCategories.add({
                    'name': nameController.text,
                    'color': selectedColor,
                  });
                });
                widget.onCategoryUpdated(localCategories);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(Map<String, dynamic> category, int index) {
    final nameController = TextEditingController(text: category['name']);
    Color selectedColor = category['color'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickColor((color) {
                  selectedColor = color;
                }),
                child: const Text('Pick New Color'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  localCategories[index] = {
                    'name': nameController.text,
                    'color': selectedColor,
                  };
                });
                widget.onCategoryUpdated(localCategories);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int index) {
    setState(() {
      localCategories.removeAt(index);
    });
    widget.onCategoryUpdated(localCategories);
  }

  void _pickColor(Function(Color) onColorPicked) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a Color'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                children: [
                  _colorCircle(Colors.blue, onColorPicked),
                  _colorCircle(Colors.green, onColorPicked),
                  _colorCircle(Colors.amber, onColorPicked),
                  _colorCircle(Colors.red, onColorPicked),
                  _colorCircle(Colors.purple, onColorPicked),
                  _colorCircle(Colors.orange, onColorPicked),
                  _colorCircle(Colors.teal, onColorPicked),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorCircle(Color color, Function(Color) onColorPicked) {
    return GestureDetector(
      onTap: () {
        onColorPicked(color);
        Navigator.of(context).pop();
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
      ),
    );
  }
}
