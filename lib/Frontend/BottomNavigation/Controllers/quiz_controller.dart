import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:chem_earth_app/utils/import_export.dart';

class QuizController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Quiz Topics
  final RxList<QuizTopicModel> _quizTopics = <QuizTopicModel>[].obs;
  List<QuizTopicModel> get quizTopics => _quizTopics;

  // All Questions loaded once
  final RxList<QuizQuestionModel> _allQuestions = <QuizQuestionModel>[].obs;

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

  // ------------------ Load Quiz Topics ------------------
  Future<void> loadQuizTopics() async {
    _isLoading.value = true;
    try {
      final String jsonString =
      await rootBundle.loadString('assets/database/quiz_questions.json');

      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert to QuizQuestionModel
      final allQs = jsonList.map((q) => QuizQuestionModel.fromMap(q)).toList();
      _allQuestions.value = allQs;

      // Extract unique topics dynamically
      final topicMap = <int, String>{};
      for (var q in allQs) {
        if (q.quizID != null && q.topicName.isNotEmpty) {
          topicMap[q.quizID!] = q.topicName;
        }
      }

      _quizTopics.value = topicMap.entries
          .map((e) => QuizTopicModel(
        quizID: e.key,
        topicName: e.value,
        description: '',
        iconPath: null,
      ))
          .toList();
    } catch (e) {
      print('Error loading JSON: $e');
      Get.snackbar(
        'Error',
        'Failed to load quiz questions',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // ------------------ Quiz Logic ------------------
  Future<void> startQuiz(int quizID, {int? questionCount}) async {
    _isLoading.value = true;
    try {
      _resetQuiz();

      // Filter questions by selected quizID
      final filteredQuestions =
      _allQuestions.where((q) => q.quizID == quizID).toList();

      if (filteredQuestions.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'No Questions',
            'No questions available for this topic',
            snackPosition: SnackPosition.BOTTOM,
          );
        });
        return;
      }

      // Shuffle questions randomly
      filteredQuestions.shuffle(Random());

      // Limit number of questions to available questions
      final int count = questionCount != null
          ? min(questionCount, filteredQuestions.length)
          : filteredQuestions.length;

      _questions.value = filteredQuestions.take(count).toList();

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

  void selectAnswer(String answer) {
    _selectedAnswer.value = answer;
  }

  void submitAnswer() {
    if (_selectedAnswer.value.isEmpty) {
      Get.snackbar(
        'Select Answer',
        'Please select an answer before continuing',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final currentQ = currentQuestion;
    if (currentQ != null && _selectedAnswer.value == currentQ.correctAnswer) {
      _score.value++;
    }

    _showExplanation.value = true;
  }

  void nextQuestion() {
    _showExplanation.value = false;
    _selectedAnswer.value = '';

    if (_currentQuestionIndex.value < _questions.length - 1) {
      _currentQuestionIndex.value++;
    } else {
      _finishQuiz();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex.value > 0) {
      _showExplanation.value = false;
      _selectedAnswer.value = '';
      _currentQuestionIndex.value--;
    }
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    _isQuizActive.value = false;

    try {
      final currentQ = this.currentQuestion;
      final result = QuizResultModel(
        quizID: currentQ?.quizID ?? 0,
        score: _score.value,
        totalQuestions: _questions.length,
        dateTaken: DateTime.now(),
        timeSpentSeconds: _timeSpent.value,
      );

      await _databaseHelper.saveQuizResult(result);

      final percentage = (_score.value / _questions.length) * 100;
      Get.to(() => QuizResultScreen(
        percentage: percentage,
        topic: currentQ?.topicName ?? 'Unknown Topic',
        quizID: currentQ?.quizID ?? 0,
      ));
    } catch (e) {
      print('Error saving quiz result: $e');
      Get.snackbar('Error', 'Failed to save quiz result',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _resetQuiz() {
    _currentQuestionIndex.value = 0;
    _score.value = 0;
    _timeSpent.value = 0;
    _selectedAnswer.value = '';
    _showExplanation.value = false;
    _questions.clear();
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeSpent.value++;
    });
  }

  void exitQuiz() {
    _timer?.cancel();
    _isQuizActive.value = false;
    _resetQuiz();
    Get.back();
  }

  Future<List<QuizResultModel>> getQuizResults({int? quizID}) async {
    try {
      final resultsData = await _databaseHelper.getQuizResults(quizID: quizID);
      return resultsData.map((data) => QuizResultModel.fromMap(data)).toList();
    } catch (e) {
      print('Error getting quiz results: $e');
      return [];
    }
  }

  String get formattedTime {
    final minutes = _timeSpent.value ~/ 60;
    final seconds = _timeSpent.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress =>
      _questions.isEmpty ? 0.0 : (_currentQuestionIndex.value + 1) / _questions.length;
}