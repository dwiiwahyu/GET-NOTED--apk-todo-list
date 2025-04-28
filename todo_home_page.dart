import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // import library kalender
import 'package:intl/intl.dart'; // import untuk format tanggal
import 'category_page.dart'; // import page category

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key}); // konstruktor untuk todohomepage

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Map<String, dynamic>> tasks = []; // list untuk nyimpen tugas yg blm kelar
  final List<Map<String, dynamic>> finishedTasks = []; // list untuk nyimpen tugas yg kelar

  List<Map<String, dynamic>> categories = [ // ini list kategori TASK bawaan aja sih
    {'name': 'Coursework', 'color': Colors.blue},
    {'name': 'Bootcamp', 'color': Colors.green},
    {'name': 'Workout', 'color': Colors.amber},
  ];

  DateTime _focusedDay = DateTime.now(); // nyimpen tanggal skrg
  DateTime? _selectedDay; // nyimpen tanggal yg dipilih

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tasks.addAll([  // ini nambahin tampilan buat contoh tugas todolist
      {
        'title': 'Laprak project mobile flutter',
        'date': DateTime(2025, 9, 15),
        'time': '19.00 - 21.00',
        'category': 'Coursework',
        'color': Colors.blue,
        'isDone': false,
      },
      {
        'title': 'Short Class Data Analyst Myskill',
        'date': DateTime(2025, 9, 15),
        'time': '19.45 - 21.00',
        'category': 'Bootcamp',
        'color': Colors.green,
        'isDone': false,
      },
      {
        'title': 'Jogging di buzem kampus',
        'date': DateTime(2025, 9, 21),
        'time': '06.00',
        'category': 'Workout',
        'color': Colors.amber,
        'isDone': false,
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent, // warna BG kalender
      body: _currentIndex == 0 // menampilkan halaman sesuai index yg aktif alias home atau category
          ? _buildHomePage()
          : CategoryPage(
              categories: categories, // untuk menampilkan kategori tugas
              onCategoryUpdated: (updatedCategories) {
                setState(() {
                  categories = updatedCategories; // untuk update kategori setelah diperbarui
                });
              },
            ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton( // menampilkan tombol tugas jika berada dihalaman home
              backgroundColor: Colors.purpleAccent, // warna BUTTON TAMBAH TUGAS
              onPressed: _showAddTaskDialog, 
              child: const Icon(Icons.add), // icon BUTTON + tugas
            )
          : null,
      bottomNavigationBar: BottomNavigationBar( // BUTTON NAVIGASI
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // ICON HALAMAN HOME
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category), // ICON HALAMAN KATEGORI
            label: 'Category',
          ),
        ],
        currentIndex: _currentIndex, // index halaman yg lagi aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // update ke halaman yg lg aktif pas klik tab
          });
        },
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        const SizedBox(height: 30), // jarak antar elemen di atas sama kalender
        _buildCalendar(), // menampilkan widget kalender
        Expanded(
          child: Container( // container ini untuk menampilkan daftar tugas
            decoration: const BoxDecoration(
              color: Color(0xFFE9E9E9), // Warna BG container
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // buat border diatasnya 
            ),
            child: Padding(
              padding: const EdgeInsets.all(16), // jarak di dalam container
              child: ListView(
                children: [
                  const Text(
                    'My To-Do List', // judul
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // teks rata tengah
                  ),
                  const SizedBox(height: 20), 
                  _buildTaskSections(), // menampilkan list tugas yg dikelompokkan berds. tgl
                  const SizedBox(height: 20),
                  _buildFinishedTasks(), // menampilkan tugas yg udah kelar
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar( // Menampilkan kalender
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2020, 1, 1), // tgl awal kalender
      lastDay: DateTime.utc(2030, 12, 31), // tgl akhir kalender 
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day), // menandai hari yg dipilih
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle), // dekorasi u hari ini
        selectedDecoration: BoxDecoration(color: Color.fromARGB(255, 145, 141, 141), shape: BoxShape.circle), // dekorasi u hari yg dipilih
        defaultTextStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // warna tanggal biasa
        weekendTextStyle: TextStyle(color: Color.fromARGB(255, 225, 255, 1)), // warna tanggal weekend
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 15, fontWeight: FontWeight.bold),  // warna teks hari biasa
        weekendStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 1), fontSize: 15, fontWeight: FontWeight.bold), // warna teks hari weekend
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true, // judul kalender
        titleTextStyle: TextStyle(
          color: Colors.white, // warna judul kalender
          fontSize: 30, // ukuran font kalender
          fontWeight: FontWeight.bold,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay; // pengaturan hair yg dipilih
          _focusedDay = focusedDay; // pengaturan hari yang difokuskan
        });
      },
    );
  }

  Widget _buildTaskSections() { // widget u menampilkan bagian tugas yg dikelompokkan ber. tanggal
    Map<DateTime, List<Map<String, dynamic>>> groupedTasks = {}; // menyimpan tugas berds tanggal

    for (var task in tasks) {
      final taskDate = DateTime(task['date'].year, task['date'].month, task['date'].day); // mendapatkan tanggal tanpa waktu
      groupedTasks.putIfAbsent(taskDate, () => []).add(task); // mengelompokkan tugas berds. tanggal
    }

    List<Widget> sections = [];
    groupedTasks.forEach((date, taskList) {
      sections.add(_buildTaskSection(DateFormat('d MMMM yyyy', 'id').format(date), taskList)); //membuat bagian tugas berds. tanggal
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections, // menampilkan bagian2 tugas
    );
  }

  Widget _buildTaskSection(String title, List<Map<String, dynamic>> tasks) { // widget untuk menampilkan bagian tugas pada tgl tertentu
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( 
          title, // tanggal yg ditampilin dibagian tugas
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10), // jarak
        ...tasks.map((task) => _buildTaskItem(task)), // menampilkan tugas
      ],
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) { // widget untuk menampilkan item tugas
    final formattedDate = DateFormat('d MMMM', 'id').format(task['date']); // format tanggal

    return Card(
      margin: const EdgeInsets.only(bottom: 12), // jarak antar card
      child: ListTile(
        leading: Container(
          width: 5,
          height: double.infinity,
          color: task['color'], // warna kategori tugas
        ),
        title: Text(
          task['title'],
          style: task['isDone'] ? const TextStyle(decoration: TextDecoration.lineThrough) : null, // jika tugas selsai pas di ceklis ada gris coret
        ),
        subtitle: Text('$formattedDate • ${task['time']}'), // meampilkan tanggal dan waktu tugas
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit), // ikon edit
              onPressed: () => _showEditTaskDialog(task), // menampilkan edit tugas
            ),
            IconButton(
              icon: const Icon(Icons.delete), // ikon hapus
              onPressed: () {
                setState(() {
                  tasks.remove(task); // menghapus tugas dari list
                });
              },
            ),
            Checkbox( 
              value: task['isDone'], // ceklis untuk menandai tugas seleai
              onChanged: (value) {
                setState(() {
                  task['isDone'] = value ?? false;
                  if (task['isDone']) {
                    finishedTasks.add(task); // menambahkan tugas selesai ke daftar tugas selesai
                    tasks.remove(task); // menghapus tugas yg selesai dari daftar tugas
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedTasks() { // widget u menampilkan tugas yg sudha selesai
    if (finishedTasks.isEmpty) return const SizedBox(); // jika tdk ada tugas yg selesai maka tidak menampilkan apa2

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Finished Tasks', // judul untuk tugas yg selesai
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...finishedTasks.map((task) => _buildFinishedTaskItem(task)), // menampilkan tugas yg selesai
      ],
    );
  }

  Widget _buildFinishedTaskItem(Map<String, dynamic> task) { // widget u menapilkan item tugas yg selesai
    final formattedDate = DateFormat('d MMMM', 'id').format(task['date']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          task['title'],
          style: const TextStyle(decoration: TextDecoration.lineThrough), // garis coret pd tugas selesai
        ),
        subtitle: Text('$formattedDate • ${task['time']}'), // menampilkan tgl dan waktu tugas selesai
      ),
    );
  }

// fungsi u menampilkan dialog tambahkan tugas
  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    DateTime selectedDate = _focusedDay;
    String? selectedCategory = categories.isNotEmpty ? categories[0]['name'] : '';
    Color selectedColor = categories.isNotEmpty ? categories[0]['color'] : Colors.blue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'), // judul
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'), // inputan judul tugas
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time (e.g. 19.00 - 21.00)'), // inputan waktu tugas
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'), // dropdown untuk memilih kategori tugas
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'],
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    selectedColor = categories.firstWhere((c) => c['name'] == value)['color']; // menampilkan warna kategori
                  });
                },
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
              setState(() {
                tasks.add({
                  'title': titleController.text,
                  'date': selectedDate,
                  'time': timeController.text,
                  'category': selectedCategory,
                  'color': selectedColor,
                  'isDone': false,
                });
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

// fungsi u menampilkan dialog edit tugas
  void _showEditTaskDialog(Map<String, dynamic> task) {
    final titleController = TextEditingController(text: task['title']);
    final timeController = TextEditingController(text: task['time']);
    String? selectedCategory = task['category'];
    Color selectedColor = task['color'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'), // judul
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'],
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    selectedColor = categories.firstWhere((c) => c['name'] == value)['color']; // menyesuaikan warna kategori
                  });
                },
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
              setState(() {
                task['title'] = titleController.text;
                task['time'] = timeController.text;
                task['category'] = selectedCategory;
                task['color'] = selectedColor;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
