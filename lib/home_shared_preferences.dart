import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSharedPreferences extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeSharedPreferences> {
  String _textoSalvo = "Nada salvo!";
  TextEditingController _campoController = TextEditingController();

  _salvar() async {
    String valorDigitado = _campoController.text;
    final prefs =
        await SharedPreferences.getInstance(); //recupera o valordigitado
    await prefs.setString('nome', valorDigitado);
    print('isso  $valorDigitado');
  }

  _recuperar() async {
    final prefs =
        await SharedPreferences.getInstance(); //recupera o valordigitado
        setState(()=> _textoSalvo = prefs.getString('nome')??" Sem valor");
        print("operaçao recuperar :  $_textoSalvo");
  }

  _remover()async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nome");
    print("opraçao reover ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manipulação de dados'),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              _textoSalvo,
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Digite algo',
                ),
                controller: _campoController,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _salvar,
                  child: Text(
                    'Salvar',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _recuperar,
                  child: Text(
                    'Ler',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _remover,
                  child: Text(
                    'Remover',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  } //aula109
}
