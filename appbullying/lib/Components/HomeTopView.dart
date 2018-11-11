import 'package:flutter/material.dart';
import 'MonthView.dart';
import 'Profile_Notification.dart';

class ImageBackground extends StatelessWidget {
  final DecorationImage backgroundImage;
  final DecorationImage profileImage;
  final VoidCallback selectbackward;
  final VoidCallback selectforward;
  final String month;
  final Animation<double> containerGrowAnimation;
  ImageBackground(
      {this.backgroundImage,
      this.containerGrowAnimation,
      this.profileImage,
      this.month,
      this.selectbackward,
      this.selectforward});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;
    return (new Container(
        width: 250,
        height: 250,
        decoration: new BoxDecoration(image: backgroundImage),
        ));
  }
}
