import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nome;
  String status;
  final _inputCodigo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("CodeIgniter 4.0 é demais!"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _inputCodigo,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Código do Usuário",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      child: Text("OK"),
                      textColor: Colors.white,
                      onPressed: () {
                        if (_inputCodigo.text != '') {
                          setState(() {
                            //To do
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getData(_inputCodigo.text),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Erro ao Carregar os Dados\n" +
                              snapshot.error.toString()),
                        );
                      }
                      if (snapshot.data['erro'] == true) {
                        return Center(
                            child: Text(
                          "${snapshot.data['mensagem']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ));
                      }
                      nome = snapshot.data['nome'];
                      status = snapshot.data['status'];                      
                      return Column(
                        children: <Widget>[
                          Text(
                            "$nome",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          status == '1'
                              ? Text('Liberado',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.greenAccent))
                              : Text('Proibido',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent)),
                        ],
                      );
                  }
                },
              ),
            )
          ],
        )));
  }

  Future<Map> getData(String codigo) async {
    http.Response response = await http.get(
        'https://codeigniter.com.br/flutter/index.php/api/getDados/$codigo');
    return json.decode(response.body);
  }
}
