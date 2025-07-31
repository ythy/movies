import 'package:flutter/material.dart';
import 'dart:math';

class InitialAnimatedBuilder extends StatelessWidget {

  const InitialAnimatedBuilder({
    required this.child,
    super.key,
    required this.controller,
    this.curve = Curves.bounceInOut,
    this.interval = const Interval(0, 1),
    this.width = 200,
    this.type = 0
  });

  final int type;

  final AnimationController controller;

  /// The widget to animate in.
  final Widget child;

  /// Curve used for the animation's easing.
  final Curve curve;

  final Interval interval;

  final double width;

  @override
  Widget build(BuildContext context) {
    var scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(interval.begin, interval.begin + 0.1,
            curve: Curves.fastEaseInToSlowEaseOut),
      ),
    );
    var opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
            interval.begin, interval.end, curve: Curves.easeOutBack),
      ),
    );

    var sizeAnimation = Tween<double>(begin: 80, end: width).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
            interval.begin + 0.1, interval.end, curve: Curves.easeInOutCubic),
      ),
    );
    var scaleAndSize = ScaleTransition(
      scale: scaleAnimation,
      child: AnimatedBuilder(
        animation: sizeAnimation,
        builder: (context, child) =>
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: sizeAnimation.value),
              child: child,
            ),
        child: child,
      ),
    );


    if (type == 1) {
      var rotationAnimation = Tween<double>(begin: pi / 3, end: 0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            interval.begin, interval.end,/* ~300ms */ curve: Curves.easeInOutCubic,),
        ),
      );
      var transform = AnimatedBuilder(
        animation: rotationAnimation,
        builder: (context, snapshot) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(rotationAnimation.value)
              ..scale(1, 1),
            child: child,
          );
        },
      );

      return transform;
    } else {
      return FadeTransition(
        opacity: opacityAnimation,
        child: scaleAndSize,
      );
    }


  }


}
