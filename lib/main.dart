import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/movie.dart';
import 'database/database_helper.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  // 🎬 試しに映画データを1つ追加（データがなければ追加）
  List<Movie> movies = await dbHelper.getMovies();
  if (movies.isEmpty) {
    await dbHelper.insertMovie(
      Movie(id: 1, title: "スーパーマン", tbd: false, date: DateTime(2025, 7, 11)),
    );
  }

  initializeDateFormatting().then((_) => runApp(MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: const CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now(); // 現在フォーカスされている日
  DateTime? _selectedDay; // 選択した日

  @override
  Widget build(BuildContext context) {
    const selectedColor = 0xFF33CCFF;
    const todayColor = 0xFFFF3300;
    return Scaffold(
      appBar: AppBar(title: const Text('MOVIEGOER')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            locale: "ja_JP",
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(todayColor), // 今日のハイライト（青）
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(selectedColor), // 選択した日のハイライト（赤）
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.white, // 今日の日付のテキスト
                fontWeight: FontWeight.bold,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white, // 選択した日のテキスト
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}