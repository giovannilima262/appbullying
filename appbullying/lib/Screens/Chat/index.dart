import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  ChatScreenState createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<Widget> listaWidget = new List();
  Map<String, dynamic> list = Map();
  var isLoading = false;
  Map contexto = {};
  final TextEditingController _mensagemController = new TextEditingController();
  _fetchData(rota) async {
    final response = await http.post("http://192.168.25.136:3000/api/message",
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "input": {"text": rota},
          "context": contexto,
        }));
    if (response.statusCode == 200) {
      list = json.decode(response.body);
      contexto = list["context"];
      setState(() {
        listaWidget.add(mensagemBot(list["output"]["text"]));
      });
    } else {
      setState(() {
        listaWidget
            .add(mensagemBot("Não entendi. Poderia reformular a pergunta?"));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      listaWidget;
    });
    _fetchData(null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mensagemBot(item) {
    return new Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: new Container(
        margin: new EdgeInsets.all(10),
        padding: new EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            color: Colors.purple,
            borderRadius: new BorderRadius.circular(20.0)),
        child: new Text(
          item[0],
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget mensagemPessoa(item) {
    return new Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: new Container(
        margin: new EdgeInsets.all(10),
        padding: new EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            color: Colors.green, borderRadius: new BorderRadius.circular(20.0)),
        child: new Text(
          item,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void enviar() {
    String mensagem = _mensagemController.value.text;
    setState(() {
      listaWidget.add(mensagemPessoa(mensagem));
    });
    _mensagemController.clear();
    _fetchData(mensagem);
    setState(() {
      listaWidget.add(list["data"]["mensagem"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Container(
            child: new Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: listaWidget.length,
                itemBuilder: (context, index) {
                  final item = listaWidget[listaWidget.length - (index + 1)];
                  return item;
                },
              ),
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _mensagemController,
                    onSubmitted: (_) {
                      enviar();
                    },
                    decoration: new InputDecoration.collapsed(
                        hintText: "Digite sua menssagem"),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => enviar(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
