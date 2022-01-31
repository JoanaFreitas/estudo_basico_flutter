import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancodadosSqflite extends StatefulWidget {
  const BancodadosSqflite({Key? key}) : super(key: key);

  @override
  _BancodadosSqfliteState createState() => _BancodadosSqfliteState();
}

class _BancodadosSqfliteState extends State<BancodadosSqflite> {
  //==METODOS/FUNCS=================
  _recuperarBancoDados() async {
    //caminho e localização bd
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, 'banco.db');
    //func q cria o bd
    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          'CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)';

      db.execute(sql);
    });
    return bd;
    //print('aberto: ' + bd.isOpen.toString());
  }

  //____________________________________
  _salvar() async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      'nome': 'marcos',
      'idade': 40,
    };
    int id = await bd.insert('usuarios', dadosUsuario);
    print('salvo: $id');
  }

  //_______________________________________
  _listarTodosUsuarios() async {
    Database bd = await _recuperarBancoDados();
    String sql = 'SELECT * FROM usuarios';
    //ver mais sobre select em https://www.w3schools.com/sql/default.asp
    List usuarios = await bd.rawQuery(sql);

    for (var usuario in usuarios) {
      print('item id: ' +
          usuario['id'].toString() +
          ' nome: ' +
          usuario['nome'] +
          ' idade: ' +
          usuario['idade'].toString());
    }
    // print('usuarios: '+usuarios.toString());
  }

  //__________________________________________
  _listarUsuarioPeloId(int id) async {
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
      'usuarios',
      columns: ['id', 'nome', 'idade'],
      where: 'id=?',
      whereArgs: [id],
      /*where: 'id=? AND nome=?',
       whereArgs: [id,'joana']*/
    );
    for (var usuario in usuarios) {
      print('item id: ' +
          usuario['id'].toString() +
          ' nome: ' +
          usuario['nome'] +
          ' idade: ' +
          usuario['idade'].toString());
    }
  }
  //________________________________________
  _excluirUsuario(int id)async{
    Database bd = await _recuperarBancoDados();
   int retorno = await bd.delete(
      'usuarios',
      where: 'id=?',
      whereArgs: [id]
    );
    print('item qtde removida: $retorno');
  }
  //_________________________________________
  _atualizarUsuario(int id)async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      'nome': 'murilo gabriel',
      'idade': 50,
    };
    int retorno = await bd.update(
      'usuarios',
      dadosUsuario,
       where: 'id=?',
      whereArgs: [id]
      );
      print('item atualizado: $retorno');
  }
  //================================
  @override
  Widget build(BuildContext context) {
    _atualizarUsuario(2);
    //_excluirUsuario(3);
   // _listarUsuarioPeloId(1);
    _listarTodosUsuarios();
    //_recuperarBancoDados();
    // _salvar();
    return Container();
  }
}
