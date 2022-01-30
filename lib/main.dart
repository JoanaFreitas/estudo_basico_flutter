import 'package:flutter/material.dart';
import 'armazenando_dados_no_app.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de tarefas',
      theme: ThemeData(       
        primarySwatch: Colors.blue,
      ),
      home: ArmazenandoDadosNoApp(),
     // home: HomeSharedPreferences(),
    );
  }
}

