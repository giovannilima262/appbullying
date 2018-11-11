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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();

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

  void popupMessageBot(
      context,
      ) {
    var mensagem = 1;
    var alert = new AlertDialog(
        title: new Text(
          "Mensagens",
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: Colors.black,
          ),
        ),
        content: new Container(
         child: mensagem != null ? new Text('Fulano, favor comparecer a coordenação', textAlign: TextAlign.justify,) : new Container(
           height: 150,
           child: new ListView(
              children: <Widget>[
                new Container(
                  child: Icon(Icons.mail, color: Colors.black38, size: 100,),
              ),
                new Container(
                  child: new Text('Não há mensagens.'),
                )
              ],
            )           
         ) 
        ));
    showDialog(context: context, child: alert);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;
    Size screenSize = MediaQuery.of(context).size;
    var num = 1;
    var image;
    switch (num){
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.mail, color: Colors.white),
              onPressed: (){
                popupMessageBot(context);
              }
            )
          ],
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
                child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ImageBackground(
                backgroundImage: new DecorationImage(
              image: new ExactAssetImage(image),
              fit: BoxFit.cover,
            ),
              )
                ],
              ),
              ),
              animateStatus == 0
                  ? new Padding(
                      padding: new EdgeInsets.all(20.0),
                      child: new InkWell(
                        splashColor: Colors.white,
                        highlightColor: Colors.white,
                        onTap: () {
                          Navigator.pushNamed(context, "/chat");
                        },
                        child: new AddButton(
                          buttonGrowAnimation: buttonGrowAnimation,
                        ),
                      ))
                  : new StaggerAnimation(
                      buttonController: _buttonController.view),
            ],
          ),
        ),
      ),
    ));
  }
}
