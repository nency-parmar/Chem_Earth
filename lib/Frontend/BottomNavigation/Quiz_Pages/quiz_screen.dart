import 'package:chem_earth_app/utils/import_export.dart';

class QuizScreen extends StatefulWidget {
  final String topic;

  const QuizScreen({super.key, required this.topic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> quizQuestions = [
    {
      'question': '1. What is the chemical symbol for water?',
      'options': ['H₂O', 'O₂', 'CO₂', 'NaCl'],
      'answer': 'H₂O',
    },
    {
      'question': '2. Which gas do plants absorb from the atmosphere?',
      'options': ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
      'answer': 'Carbon Dioxide',
    },
    {
      'question': '3. What is the pH of pure water?',
      'options': ['7', '0', '14', '1'],
      'answer': '7',
    },
    {
      'question': '4. Which of these is a noble gas?',
      'options': ['Oxygen', 'Nitrogen', 'Helium', 'Hydrogen'],
      'answer': 'Helium',
    },
    {
      'question': '5. What is NaCl commonly known as?',
      'options': ['Baking Soda', 'Sugar', 'Salt', 'Bleach'],
      'answer': 'Salt',
    },
  ];

  Map<int, String> selectedAnswers = {};

  void _submitQuiz() {
    int correct = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (selectedAnswers[i] == quizQuestions[i]['answer']) {
        correct++;
      }
    }

    double percentage = (correct / quizQuestions.length) * 100;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(percentage: percentage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Quiz - ${widget.topic}'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              ...List.generate(quizQuestions.length, (questionIndex) {
                final q = quizQuestions[questionIndex];
                final questionText = q['question'];
                final options = q['options'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: isDark ? Border.all(color: Colors.white10) : null,
                    boxShadow: isDark
                        ? []
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionText,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(options.length, (index) {
                          final option = options[index];
                          final isSelected =
                              selectedAnswers[questionIndex] == option;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAnswers[questionIndex] = option;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                    ? Colors.blueGrey.withOpacity(0.2)
                                    : Colors.blueGrey.shade100)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    size: 20,
                                    color: isSelected
                                        ? Colors.blueGrey
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style:
                                      theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.85),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitQuiz,
                icon: const Icon(Icons.check_circle_outline,
                    color: Colors.white),
                label: const Text(
                  'Submit Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}