import 'dart:async';

import 'package:flutter/material.dart';
import 'custom_filter_dialogs.dart' as picker;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  DateTime first = DateTime(2020, 8);
  DateTime last = DateTime(2101);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await picker.showCustomDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: first,
      lastDate: last,
      controlColor: Colors.yellow,
      todayColor: Colors.blue,
      enabledDayColor: Colors.green,
      disabledDayColor: Colors.green,
      selectedDayColor: Colors.white,
      selectedDayBackground: Colors.red,
      monthControlIconLeft: const Icon(Icons.chevron_left),
      monthControlIconRight: const Icon(Icons.chevron_right),
      dropDownIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.yellow,
      ),
      weekdayAxisColor: Colors.blue,
      currentYearColor: Colors.blue,
      enabledYearColor: Colors.green,
      disabledYearColor: Colors.green,
      selectedYearBackground: Colors.red,
      selectedYearColor: Colors.white,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select date'),
            ),
          ],
        ),
      ),
    );
  }
}
