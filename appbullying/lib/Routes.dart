import 'package:appbullying/Screens/Chat/index.dart';
import 'package:appbullying/Screens/HomeCoordenador/index.dart';
import 'package:flutter/material.dart';
import 'package:appbullying/Screens/Login/index.dart';
import 'package:appbullying/Screens/Home/index.dart';

class Routes {
  Routes() {
    runApp(new MaterialApp(
      title: "Dribbble Animation App",
      debugShowCheckedModeBanner: false,
      home: new LoginScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MyCustomRoute(
              builder: (_) => new LoginScreen(),
              settings: settings,
            );

          case '/home':
            return new MyCustomRoute(
              builder: (_) => new HomeScreen(),
              settings: settings,
            );
          case '/chat':
            return new MyCustomRoute(
              builder: (_) => new ChatScreen(),
              settings: settings,
            );
          case '/home-coordenador':
            return new MyCustomRoute(
              builder: (_) => new HomeCoordenadorScreen(),
              settings: settings,
            );
        }
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}
