import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullScreenAnimation extends StatelessWidget {
  const FullScreenAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Lottie.asset(
          'assets/animations/success.json',
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              // ScaffoldMessenger.of(context).showSnackBar(
                  // const SnackBar(
                  //   content: Text('Order Placed Successfully!'),
                  //   duration: Duration(seconds: 2),
                  // )
              // );

              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.of(context).pop();
              });
            });
          },
        ),
      ),
    );
  }
}
