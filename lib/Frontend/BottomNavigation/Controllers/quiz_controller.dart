import 'package:get/get.dart';
import 'package:chem_earth_app/utils/import_export.dart';
import 'dart:async';

class QuizController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Quiz Topics
  final RxList<QuizTopicModel> _quizTopics = <QuizTopicModel>[].obs;
  List<QuizTopicModel> get quizTopics => _quizTopics;

  // Current Quiz State
  final RxList<QuizQuestionModel> _questions = <QuizQuestionModel>[].obs;
  final RxInt _currentQuestionIndex = 0.obs;
  final RxInt _score = 0.obs;
  final RxInt _timeSpent = 0.obs;
  final RxBool _isQuizActive = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedAnswer = ''.obs;
  final RxBool _showExplanation = false.obs;

  Timer? _timer;

  // Getters
  List<QuizQuestionModel> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex.value;
  int get score => _score.value;
  int get timeSpent => _timeSpent.value;
  bool get isQuizActive => _isQuizActive.value;
  bool get isLoading => _isLoading.value;
  String get selectedAnswer => _selectedAnswer.value;
  bool get showExplanation => _showExplanation.value;

  QuizQuestionModel? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex.value < _questions.length
          ? _questions[_currentQuestionIndex.value]
          : null;

  int get totalQuestions => _questions.length;
  bool get isLastQuestion => _currentQuestionIndex.value >= _questions.length - 1;

  @override
  void onInit() {
    super.onInit();
    loadQuizTopics();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Load all quiz topics
  Future<void> loadQuizTopics() async {
    try {
      _isLoading.value = true;
      final topicsData = await _databaseHelper.getAllQuizTopics();
      _quizTopics.value = topicsData
          .map((data) => QuizTopicModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error loading quiz topics: $e');
      Get.snackbar(
        'Error',
        'Failed to load quiz topics',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Start a quiz for a specific topic
  Future<void> startQuiz(int quizID, {int? questionCount}) async {
    try {
      _isLoading.value = true;
      _resetQuiz();

      final questionsData = await _databaseHelper.getQuizQuestions(
        quizID,
        limit: questionCount ?? 10,
      );

      if (questionsData.isEmpty) {
        Get.snackbar(
          'No Questions',
          'No questions available for this topic',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _questions.value = questionsData
          .map((data) => QuizQuestionModel.fromMap(data))
          .toList();

      _isQuizActive.value = true;
      _startTimer();

    } catch (e) {
      print('Error starting quiz: $e');
      Get.snackbar(
        'Error',
        'Failed to start quiz',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Select an answer
  void selectAnswer(String answer) {
    _selectedAnswer.value = answer;
  }

  // Submit current answer and move to next question
  void submitAnswer() {
    if (_selectedAnswer.value.isEmpty) {
      Get.snackbar(
        'Select Answer',
        'Please select an answer before continuing',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check if answer is correct
    final currentQ = currentQuestion;
    if (currentQ != null && _selectedAnswer.value == currentQ.correctAnswer) {
      _score.value++;
    }

    // Show explanation
    _showExplanation.value = true;
  }

  // Move to next question
  void nextQuestion() {
    _showExplanation.value = false;
    _selectedAnswer.value = '';

    if (_currentQuestionIndex.value < _questions.length - 1) {
      _currentQuestionIndex.value++;
    } else {
      // Quiz completed
      _finishQuiz();
    }
  }

  // Go to previous question (if needed)
  void previousQuestion() {
    if (_currentQuestionIndex.value > 0) {
      _showExplanation.value = false;
      _selectedAnswer.value = '';
      _currentQuestionIndex.value--;
    }
  }

  // Finish the quiz and save results
  Future<void> _finishQuiz() async {
    _timer?.cancel();
    _isQuizActive.value = false;

    try {
      // Save quiz result
      final result = QuizResultModel(
        quizID: currentQuestion?.quizID,
        score: _score.value,
        totalQuestions: _questions.length,
        dateTaken: DateTime.now(),
        timeSpentSeconds: _timeSpent.value,
      );

      await _databaseHelper.saveQuizResult(result);

      // Navigate to result screen
      final percentage = (_score.value / _questions.length) * 100;
      Get.to(() => QuizResultScreen(
        percentage: percentage,
      ));

    } catch (e) {
      print('Error saving quiz result: $e');
    }
  }

  // Reset quiz state
  void _resetQuiz() {
    _currentQuestionIndex.value = 0;
    _score.value = 0;
    _timeSpent.value = 0;
    _selectedAnswer.value = '';
    _showExplanation.value = false;
    _questions.clear();
    _timer?.cancel();
  }

  // Start timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeSpent.value++;
    });
  }

  // Exit quiz
  void exitQuiz() {
    _timer?.cancel();
    _isQuizActive.value = false;
    _resetQuiz();
    Get.back();
  }

  // Get quiz results history
  Future<List<QuizResultModel>> getQuizResults({int? quizID}) async {
    try {
      final resultsData = await _databaseHelper.getQuizResults(quizID: quizID);
      return resultsData
          .map((data) => QuizResultModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting quiz results: $e');
      return [];
    }
  }

  // Format time display
  String get formattedTime {
    final minutes = _timeSpent.value ~/ 60;
    final seconds = _timeSpent.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Get progress percentage
  double get progress => _questions.isEmpty
      ? 0.0
      : (_currentQuestionIndex.value + 1) / _questions.length;
}