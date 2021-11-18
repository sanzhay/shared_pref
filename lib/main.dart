import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SharedPreferenceExample(),
    );
  }
}

class SharedPreferenceExample extends StatefulWidget {
  @override
  _SharedPreferenceExampleState createState() =>
      _SharedPreferenceExampleState();
}

class _SharedPreferenceExampleState extends State<SharedPreferenceExample> {
  int _numberPref = 0;
  bool _boolPref = false;

  static const String kNumberPrefKey = 'number_pref';
  static const String kBoolPrefKey = 'bool_pref';

  SharedPreferences? _prefs;

  Future<Null> _setNumberPref(int value) async {
    await this._prefs!.setInt(kNumberPrefKey, value);
    _loadNumberPref();
  }

  Future<Null> _setBoolPref(bool value) async {
    await this._prefs!.setBool(kBoolPrefKey, value);
    _loadBoolPref();
  }

// считываем данные с хранилища
  void _loadNumberPref() {
    setState(() {
      _numberPref = _prefs!.getInt(kNumberPrefKey) ?? 0;
    });
  }

  void _loadBoolPref() {
    setState(() {
      _boolPref = _prefs!.getBool(kBoolPrefKey) ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() {
          _prefs = prefs;
          _loadNumberPref();
          _loadBoolPref();
        });
      });
  }

  Future<Null> _resetDataPref() async {
    await _prefs!.remove(kNumberPrefKey);
    await _prefs!.remove(kBoolPrefKey);
    _loadBoolPref();
    _loadNumberPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Pref'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Number preference $_numberPref"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      _setNumberPref(_numberPref + 1);
                    },
                    child: Text("Increment"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Boolean Preference $_boolPref"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      _setBoolPref(!_boolPref);
                    },
                    child: Text("Toggle"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _resetDataPref();
                },
                child: Text("Reset Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
