import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tp2_amov/Utils.dart';
import 'package:tp2_amov/WeekDay.dart';
import 'package:tp2_amov/edit_screen.dart';

import 'Menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TP2 / AMOV / CANTINA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  static const menuApiUrl = "$address/menu";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<WeekDay> _menuData = [];
  static const List<String> weekDays = [
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY"
  ];
  bool _fetchingData = false;

  Future<void> _fetchData() async {
    try {
      _menuData.clear();
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse(MyHomePage.menuApiUrl));
      if (response.statusCode == 200) {
        String utf8String = utf8.decoder.convert(response.bodyBytes);
        final Map<String, dynamic> decodedData = json.decode(utf8String);

        int currentWeekDay = DateTime.now().weekday - 1;
        List<String> newWeekDays = weekDays.sublist(currentWeekDay)
          ..addAll(weekDays.sublist(0, currentWeekDay));

        for (String day in newWeekDays) {
          WeekDay weekDay = new WeekDay();
          weekDay.original = Menu.fromJson(decodedData[day]['original']);
          weekDay.update = decodedData[day]['update'] != null
              ? Menu.fromJson(decodedData[day]['update'])
              : null;
          weekDay.weekDay = day;

          setState(() =>_menuData.add(weekDay));
        }
      }
    } catch (ex) {
      debugPrint('Something went wrong: $ex');
    } finally {
      setState(() => _fetchingData = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10.0),
          if (_fetchingData) const CircularProgressIndicator(),
          if (!_fetchingData && _menuData.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: _menuData.length,
                separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                itemBuilder: (BuildContext context, int index) => ListTile(
                  leading: _menuData[index].getImgUrl() != null ? Image.network(_menuData[index].getImgUrl()!) : null,
                  title: Text(_menuData[index].weekDay),
                  subtitle: Text(_menuData[index].toString(),
                      style: TextStyle(
                          color: (_menuData[index].update != null ? Colors.red : Colors.black))),
                  onTap: () {
                    // Push a new route onto the navigation stack
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(),
                        settings: RouteSettings(
                            arguments: _menuData[index]
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
