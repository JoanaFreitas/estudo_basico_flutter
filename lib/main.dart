import 'package:flutter/material.dart';
import 'package:lista_tarefas_shared_preferences/home_shared_preferences.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de tarefas',
      theme: ThemeData(       
        primarySwatch: Colors.blue,
      ),
      home: HomeSharedPreferences(),
    );
  }
}

