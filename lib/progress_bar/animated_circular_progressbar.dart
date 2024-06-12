import 'package:flutter/material.dart';

class AnimatedCircularProgressIndicator extends StatefulWidget {
  @override
  _AnimatedCircularProgressIndicatorState createState() => _AnimatedCircularProgressIndicatorState();
}

class _AnimatedCircularProgressIndicatorState extends State<AnimatedCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Adjust duration as needed
    );

    _colorAnimation = ColorTween(begin: Colors.grey, end: Colors.blue).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color?>(_colorAnimation.value),
                strokeWidth: 5,
              ),
            ),
          );
        },
      ),
    );
  }
}
