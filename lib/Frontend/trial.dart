import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedChemicalBackground extends StatefulWidget {
  const AnimatedChemicalBackground({super.key});

  @override
  State<AnimatedChemicalBackground> createState() => _AnimatedChemicalBackgroundState();
}

class _AnimatedChemicalBackgroundState extends State<AnimatedChemicalBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Chemistry elements
  final List<String> elements = [
    'H', 'He', 'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Ne',
    'Na', 'Mg', 'CO2', 'Si', 'O2', 'S', 'Cl', 'Ar', 'K', 'Ca',
    'Sc', 'Ti', 'V', 'Cr', 'Mn', 'H2O', 'Co', 'Ni', 'Cu', 'Zn',
  ];


  final List<double> _horizontalOffsets = [];
  final List<double> _delayOffsets = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    final random = Random();
    for (int i = 0; i < elements.length; i++) {
      _horizontalOffsets.add(random.nextDouble());  // X-position base
      _delayOffsets.add(random.nextDouble());       // Delay for staggered animation
    }
  }

  Widget _buildMovingElement(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = (_controller.value + _delayOffsets[index]) % 1.0;

        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;

        // Diagonal wave movement
        double top = progress * screenHeight;
        double left = (_horizontalOffsets[index] + sin(progress * 2 * pi) * 0.1) * screenWidth;

        return Positioned(
          top: top,
          left: left.clamp(0.0, screenWidth - 50),
          child: Opacity(
            opacity: 0.6,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1), // transparent bubble
                border: Border.all(color: Colors.purple.shade200.withOpacity(0.5), width: 1.5),
              ),
              child: Text(
                elements[index],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.withOpacity(0.7),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ChemEarth',style: TextStyle(color: Colors.white),),backgroundColor: Colors.blueGrey,),
      body: Stack(
        children: [
          // Animated elements
          for (int i = 0; i < elements.length; i++) _buildMovingElement(i),

          // App content
          Center(
            child: Text(
              "No Data Found!!",
              style: TextStyle(
                fontSize: 40,
                color: Colors.blueGrey.shade200,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}