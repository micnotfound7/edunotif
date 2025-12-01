import 'package:flutter/material.dart';

class PastelBackground extends StatelessWidget {
  final Widget child;

  const PastelBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFDE2E4), // soft pink
            Color(0xFFE2ECE9), // soft mint
            Color(0xFFE8E8F8), // lavender
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
