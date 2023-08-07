import 'package:flutter/material.dart';

class SplashAnimatedImage extends StatefulWidget {
  const SplashAnimatedImage({Key? key}) : super(key: key);

  @override
  State<SplashAnimatedImage> createState() => _SplashAnimatedImageState();
}

class _SplashAnimatedImageState extends State<SplashAnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);
  late final Animation<Offset> _animation = Tween(
    begin: const Offset(0, 0),
    end: const Offset(0, 0.20),
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInBack));

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Image.asset("images/logo.png"),
    );
  }
}
