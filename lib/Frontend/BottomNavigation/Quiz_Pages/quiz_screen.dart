import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chem_earth_app/utils/import_export.dart';

class QuizScreen extends StatelessWidget {
  final String topic;
  final int quizID;
  final int questionCount;

  QuizScreen({
    super.key,
    required this.topic,
    required this.quizID,
    this.questionCount = 10,
  });

  final QuizController _quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    // Start the quiz only once when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quizController.startQuiz(quizID, questionCount: questionCount);
    });

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Quiz - $topic'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Obx(() {
          if (_quizController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_quizController.isQuizActive) {
            return const Center(child: Text("No Questions Available"));
          }

          final question = _quizController.currentQuestion!;
          final questionIndex = _quizController.currentQuestionIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListView(
              children: [
                const SizedBox(height: 8),
                Container(
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
                          "${questionIndex + 1}. ${question.question}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(question.options.length, (index) {
                          final option = question.options[index];
                          final isSelected =
                              _quizController.selectedAnswer == option;
                          final isCorrect = option == question.correctAnswer;

                          Color? optionColor;
                          if (_quizController.showExplanation) {
                            if (isSelected && isCorrect) {
                              optionColor = Colors.green.shade300; // Correct
                            } else if (isSelected && !isCorrect) {
                              optionColor = Colors.red.shade300; // Wrong
                            } else if (!isSelected && isCorrect) {
                              optionColor = Colors.green.shade200; // Correct answer
                            } else {
                              optionColor = Colors.transparent;
                            }
                          } else {
                            optionColor = isSelected
                                ? (isDark
                                ? Colors.blueGrey.withOpacity(0.2)
                                : Colors.blueGrey.shade100)
                                : Colors.transparent;
                          }

                          return GestureDetector(
                            onTap: () {
                              if (!_quizController.showExplanation) {
                                _quizController.selectAnswer(option);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: optionColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: isSelected
                                        ? Colors.blueGrey
                                        : Colors.grey.withOpacity(0.5),
                                    width: 1.2),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    size: 22,
                                    color: _quizController.showExplanation
                                        ? (isCorrect
                                        ? Colors.green
                                        : isSelected
                                        ? Colors.red
                                        : Colors.grey)
                                        : (isSelected
                                        ? Colors.blueGrey
                                        : Colors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.85),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        if (_quizController.showExplanation)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              "Explanation: ${question.explanation}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.orangeAccent,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (questionIndex > 0)
                      ElevatedButton.icon(
                        onPressed: _quizController.previousQuestion,
                        icon: const Icon(Icons.arrow_back,color: Colors.white,),
                        label: const Text("Previous",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade700,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (!_quizController.showExplanation) {
                          _quizController.submitAnswer();
                        } else {
                          _quizController.nextQuestion();
                        }
                      },
                      icon: Icon(_quizController.showExplanation
                          ? Icons.arrow_forward
                          : Icons.check,color: Colors.white,),
                      label: Text(_quizController.showExplanation
                          ? "Next"
                          : "Submit",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade800,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                LinearProgressIndicator(
                  value: _quizController.progress,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blueGrey,
                  minHeight: 8,
                ),
                const SizedBox(height: 10),
                Text(
                  "Time: ${_quizController.formattedTime}",
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
