import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final Animation<double> buttonGrowAnimation;
  AddButton({this.buttonGrowAnimation});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: buttonGrowAnimation.value * 60,
      height: buttonGrowAnimation.value * 60,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
          color: new Color.fromRGBO(100, 193, 150, 1),
          shape: BoxShape.circle),
      child: new Icon(
        Icons.chat,
        size: buttonGrowAnimation.value * 30.0,
        color: Colors.white,
      ),
    ));
  }
}
