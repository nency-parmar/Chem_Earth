import 'package:chem_earth_app/utils/import_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<void> _delayFuture;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Complete in 4 seconds
    )..forward();

    // Schedule navigation after 5 seconds, only if the widget is still mounted
    _delayFuture = Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Get.off(() => Dashboard());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();  // Dispose controller here only
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFe0f7fa), Color(0xFFffffff)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Decorative Chemistry Icons (very light opacity)
          Positioned(
            top: 50,
            left: 24,
            child: Opacity(
              opacity: 0.08,
              child: Icon(
                Icons.science,
                size: width * 0.33,
                color: const Color(0xFF00acc1),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 36,
            child: Opacity(
              opacity: 0.055,
              child: Icon(
                Icons.bubble_chart_rounded,
                size: width * 0.28,
                color: const Color(0xFF69f0ae),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Chem Earth logo with shadow and soft glow
                    Container(
                      width: width * 0.46,
                      height: width * 0.46,
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white60,
                            blurRadius: 32,
                            spreadRadius: 5,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        color: Colors.white.withOpacity(0.0),
                      ),
                      child: Image.asset(
                        'assets/images/logowithouttext.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // App name (bolder, colored)
                    Text(
                      'Explore Chemistry Wonders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5,
                        color: Colors.teal[800]?.withOpacity(0.87),
                        letterSpacing: 0.95,
                      ),
                    ),
                    const SizedBox(height: 34),
                    // Animated Loading Bar
                    SizedBox(
                      width: width * 0.35,
                      height: 9,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              // Static bar (background)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                ),
                              ),
                              // Progress bar (animated foreground)
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _controller.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF039be5),
                                        Color(0xFF00b8d4),
                                        Color(0xFF69f0ae),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x7728b4d6).withOpacity(0.24),
                                        blurRadius: 14,
                                        spreadRadius: 2,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Two responsive logos at the bottom
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final spacing = width * 0.06;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/du_logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: spacing.clamp(16, 40)),
                    Image.asset(
                      'assets/images/aswdc_black.jpeg',
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ],
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}
