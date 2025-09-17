import 'package:chem_earth_app/utils/import_export.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final double percentage;
  final String topic;
  final int quizID; // non-nullable

  const QuizResultScreen({
    super.key,
    required this.percentage,
    required this.topic,
    required this.quizID,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool showBackButton = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    String feedback = widget.percentage == 100
        ? 'Good job! Keep it up!'
        : 'Do more hard work. You can do better!';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    showBackButton = false;
                  });

                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.off(() => QuizScreen(
                      topic: widget.topic,
                      quizID: widget.quizID,
                      questionCount: 10, // Default or previously selected count
                    ));
                  });
                },
                icon: const Icon(Icons.replay, color: Colors.white),
                label: const Text(
                  'Give Test Again',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  icon: const Icon(Icons.dashboard, color: Colors.white),
                  label: const Text(
                    'Back to Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
