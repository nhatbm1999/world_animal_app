import 'package:animal_world_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const path = '/splash';

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Lottie.asset(Assets.gif.splashScreen),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
