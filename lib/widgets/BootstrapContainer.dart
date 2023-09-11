import 'package:flutter/material.dart';

class BootstrapContainer extends StatelessWidget {
  final Widget child;
const BootstrapContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double horizontalPadding;
    if (width > 1200) {
      horizontalPadding = (width - 1140) / 2; // xl
    } else if (width > 992) {
      horizontalPadding = (width - 960) / 2; // lg
    } else if (width > 768) {
      horizontalPadding = (width - 720) / 2; // md
    } else {
      horizontalPadding = 15; // sm and xs
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: child,
    );
  }
}