import 'dart:ui'; // Import for BackdropFilter and ImageFilter
import 'package:flutter/material.dart';
import 'home_page.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleFade;
  late Animation<double> _contentFade;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _titleFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() => _showContent = true);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with blur effect initially
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 1000),
              child: _showContent
                  ? Image.asset(
                'assets/intro.jpg',
                key: ValueKey('clearImage'),
                fit: BoxFit.cover, // Ensures the image fits the screen
                height: double.infinity,  // Ensures full height coverage
                width: double.infinity,   // Ensures full width coverage
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text("Image not found"));
                },
              )
                  : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Image.asset(
                  'assets/intro.jpg',
                  key: ValueKey('blurredImage'),
                  fit: BoxFit.cover, // Ensures the image fits the screen
                  height: double.infinity,  // Ensures full height coverage
                  width: double.infinity,   // Ensures full width coverage
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text("Image not found"));
                  },
                ),
              ),
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),

          // Animated app title
          Center(
            child: AnimatedBuilder(
              animation: _titleFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _titleFade.value,
                  child: Transform.scale(
                    scale: 1.0 + (1 - _titleFade.value) * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SUITE DREAM",
                          style: TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Animated content (after the title animation finishes)
          if (_showContent)
            AnimatedBuilder(
              animation: _contentFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentFade.value,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Find & Book Your\nPerfect Stay Instantly!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 6,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Browse top hotels, book in seconds,\nand enjoy a perfect stay!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              minimumSize: Size(200, 50),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage(userName: '')),
                              );
                            },
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
