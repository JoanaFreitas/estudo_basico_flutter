import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';//aula115

//salvando usando sistemas de arquivos dentro do app
class ArmazenandoDadosNoApp extends StatefulWidget {
  const ArmazenandoDadosNoApp({Key? key}) : super(key: key);

  @override
  _ArmazenandoDadosNoAppState createState() => _ArmazenandoDadosNoAppState();
}

class _ArmazenandoDadosNoAppState extends State<ArmazenandoDadosNoApp> {
  List _listaTarefas = [];
  Map<String, dynamic> _ultimaTarefaRemovida = Map();
  TextEditingController _controllerTarefa = TextEditingController();

//==METODOS============================
  Future<File> _getFile() async {
    final diretorio =
        await getApplicationDocumentsDirectory(); //recuperaolocal o diretorio
//print('caminho' +diretorio.path);
//criando o caminho + o arquivo 'dados.json'
    return File("${diretorio.path}/dados.json");
  }

  //____________________________________
  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = textoDigitado;
    tarefa['realizada'] = false;
    setState(() => _listaTarefas.add(tarefa));
    _salvarArquivo();
    _controllerTarefa.text = '';
  }

//_____________________________________
  _salvarArquivo() async {
    var arquivo = await _getFile();
//transformado os dados em .json
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

//__________________________________
  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }
//++++++++++++++++++++++++

//pode fazer alterações antes de carregar o build
  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

//++++++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    // _salvarArquivo();
   // print('itens:  ' + _listaTarefas.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tarefas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index) {

                 // final item = _listaTarefas[index]['titulo'];

                  return Dismissible(
                    //isso ai gera chaves baseada em milisseconds, va sempreser n diferente
                     key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                    background: Container(color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete,
                        color: Colors.white,)
                      ],
                    ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction){
                      //recupera ultimo excluido
                      _ultimaTarefaRemovida=_listaTarefas[index];
                      //remove item da lista
                      setState(()=>_listaTarefas.removeAt(index));
                      _salvarArquivo();
                      //Snacbar
                      final snackbar = SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text('tarefa removida!!'),
                        action: SnackBarAction(
                          label:'Desfazer' , 
                          onPressed: (){
                            setState(() {
                            _listaTarefas.insert(index, _ultimaTarefaRemovida);                            
                            });
                            _salvarArquivo();
                          }),
                      );
                      Scaffold.of(context).showSnackBar(snackbar);
                    },
                                      child: CheckboxListTile(
                        title: Text(_listaTarefas[index]['titulo']),
                        value: _listaTarefas[index]['realizada'],
                        onChanged: (valorAlterado) {
                          setState(() {
                            _listaTarefas[index]['realizada'] = valorAlterado;
                          });
                          _salvarArquivo();
                        }),
                  );
                  /* ListTile(
                    title: Text(_listaTarefas[index]['titulo']),
                  );*/
                }),
          )
        ],
      ),

      //----------------------------------
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endDocked, //faz ele misturar com o bottomnavegatorBar
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed:(){},
      //   icon: Icon(Icons.add_shopping_cart),
      //   label: Text('Adicionar'),
      //   shape: BeveledRectangleBorder(
      //     borderRadius: BorderRadius.circular(0),//o valor muda a forma do rectagle
      //     ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.green,
        elevation: 6,
        //mini: true,
        child: Icon(Icons.add),
        onPressed: () {
          //++++++++++++
          showDialog(
              context: context,
              builder: (context) {
                //_________________
                return AlertDialog(
                  title: Text('Adicionar Tarefa'),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: 'Digite sua tarefa'),
                    onChanged: (text) {},
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                        child: Text('Salvar'),
                        onPressed: () {
                          _salvarTarefa();
                          Navigator.pop(context);
                        })
                  ],
                );
              });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape:
            CircularNotchedRectangle(), //componente faz a curvinha do floatingActionBottom
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu),
            )
          ],
        ),
      ),
    );
  }
}
