import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loading_spin extends StatelessWidget {
  const loading_spin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple.shade800,
      child: Center(
        child: SpinKitWanderingCubes(
          color: Colors.white70,
          size: 40,
        ),
      ),

    );
  }
}
