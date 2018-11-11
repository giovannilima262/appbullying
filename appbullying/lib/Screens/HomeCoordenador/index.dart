import 'dart:convert';

import 'package:flutter/material.dart';
import 'styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/ListViewContainer.dart';
import '../../Components/AddButton.dart';
import '../../Components/HomeTopView.dart';
import '../../Components/FadeContainer.dart';
import 'homeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:http/http.dart' as http;

class HomeCoordenadorScreen extends StatefulWidget {
  const HomeCoordenadorScreen({Key key}) : super(key: key);

  @override
  HomeCoordenadorScreenState createState() => new HomeCoordenadorScreenState();
}

class HomeCoordenadorScreenState extends State<HomeCoordenadorScreen>
    with TickerProviderStateMixin {
  Animation<double> containerGrowAnimation;
  AnimationController _screenController;
  AnimationController _buttonController;
  Animation<double> buttonGrowAnimation;
  Animation<double> listTileWidth;
  Animation<Alignment> listSlideAnimation;
  Animation<Alignment> buttonSwingAnimation;
  Animation<EdgeInsets> listSlidePosition;
  Animation<Color> fadeScreenAnimation;
  var animateStatus = 0;

  String month = new DateFormat.MMMM().format(
    new DateTime.now(),
  );
  int index = new DateTime.now().month;
  List<Widget> listaWidget = new List();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1500), vsync: this);

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );
    containerGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

    buttonGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOut,
    );
    containerGrowAnimation.addListener(() {
      this.setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

    listTileWidth = new Tween<double>(
      begin: 1000.0,
      end: 600.0,
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.bounceIn,
        ),
      ),
    );

    listSlideAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.700,
          curve: Curves.ease,
        ),
      ),
    );
    buttonSwingAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.ease,
        ),
      ),
    );
    listSlidePosition = new EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 16.0),
      end: const EdgeInsets.only(bottom: 80.0),
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );
    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  _fetchData() async {
    final response = await http.get("http://192.168.25.65:8000/api/get/tipo/a");
    if (response.statusCode == 200) {
      setState(() {
        listaWidget
            .add(modelocard(json.decode(response.body)["users"] as List));
      });
    }
  }

  Widget modelocard(List aluno) {
    listaWidget = new List();
    var count = 0;
    for (var item in aluno) {
      count++;
      listaWidget.add(
        new Container(
          child: new Card(
            child: new Container(
              margin: new EdgeInsets.all(20),
              child: new Row(
                children: <Widget>[
                  new Text(count.toString() + "  "),
                  new Text(item["name"]),
                  new Expanded(
                    child: new Container(
                      alignment: Alignment.centerRight,
                      child: new IconButton(
                        onPressed: (){},
                        icon: new Icon(
                          Icons.mail,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchData();
    timeDilation = 0.3;
    Size screenSize = MediaQuery.of(context).size;
    var num = 1;
    var image;
    switch (num) {
      case 1:
        image = 'assets/feliz.png';
        break;
      case 2:
        image = 'assets/neutro.png';
        break;
      case 3:
        image = 'assets/triste.png';
        break;
    }
    return (new WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: new Color.fromRGBO(100, 193, 150, 1),
          title: new Text("Quatro Olhos"),
        ),
        body: new Container(
          width: screenSize.width,
          height: screenSize.height,
          child: new Stack(
            //alignment: buttonSwingAnimation.value,
            alignment: Alignment.bottomRight,
            children: <Widget>[
              new Container(
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: listaWidget.length,
                  itemBuilder: (context, index) {
                    final item = listaWidget[index];
                    return item;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
