import 'package:chem_earth_app/utils/import_export.dart';

class QuizResultScreen extends StatefulWidget {
  final double percentage;

  const QuizResultScreen({super.key, required this.percentage});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool showBackButton = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    String feedback = widget.percentage == 100
        ? 'Good job! Keep it up!'
        : 'Do more hard work. You can do better!';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Score',
                style: TextStyle(
                  fontSize: 28,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                feedback,
                style: TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Give Test Again
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    showBackButton = false; // Hide "Back to Dashboard"
                  });

                  Future.delayed(Duration(milliseconds: 100), () {
                    Get.off(() => QuizScreen(topic: 'YourTopicHere')); // Replace topic
                  });
                },
                label: const Text(
                  'Give Test Again',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.replay, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Conditionally show Back to Dashboard
              if (showBackButton)
                ElevatedButton.icon(
                  onPressed: () {
                    Get.offAll(() => Dashboard());
                  },
                  label: const Text(
                    'Back to Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.dashboard, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}