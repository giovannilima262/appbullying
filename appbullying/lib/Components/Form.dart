import 'package:flutter/material.dart';
import './InputFields.dart';

class FormContainer extends StatelessWidget {
  TextEditingController userController;
  TextEditingController senhaController;
  FormContainer(TextEditingController userController, TextEditingController senhaController){
    this.userController = userController;
    this.senhaController = senhaController;
  }

  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new InputFieldArea(
                controller: userController,
                hint: "Usuário",
                obscure: false,
                icon: Icons.person_outline,
              ),
              new InputFieldArea(
                controller: senhaController,
                hint: "Senha",
                obscure: true,
                icon: Icons.lock_outline,
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
