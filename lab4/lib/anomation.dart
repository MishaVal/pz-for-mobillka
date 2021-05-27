import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnimationPageState();
  }
}

class AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Animation<Color> color;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          })
          ..addListener(() {
            setState(() {});
          });

    var curve = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = Tween<double>(begin: 200, end: 400).animate(curve);

    color =
        ColorTween(begin: Colors.green, end: Colors.blue).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: animation.value,
          height: animation.value,
          color: color.value,
        ),
      ),
    );
  }
}
