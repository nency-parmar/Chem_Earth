class QuizTopicModel {
  final int? quizID;
  final String topicName;
  final String description;
  final String? iconPath;

  QuizTopicModel({
    this.quizID,
    required this.topicName,
    required this.description,
    this.iconPath,
  });

  factory QuizTopicModel.fromMap(Map<String, dynamic> map) {
    return QuizTopicModel(
      quizID: map['QuizID'],
      topicName: map['TopicName'] ?? '',
      description: map['Description'] ?? '',
      iconPath: map['IconPath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'QuizID': quizID,
      'TopicName': topicName,
      'Description': description,
      'IconPath': iconPath,
    };
  }
}

class QuizQuestionModel {
  final int? questionID;
  final int? quizID;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String explanation;
  final String difficulty; // Easy, Medium, Hard

  QuizQuestionModel({
    this.questionID,
    this.quizID,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.explanation,
    this.difficulty = 'Medium',
  });

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map) {
    return QuizQuestionModel(
      questionID: map['QuestionID'],
      quizID: map['QuizID'],
      question: map['Question'] ?? '',
      optionA: map['OptionA'] ?? '',
      optionB: map['OptionB'] ?? '',
      optionC: map['OptionC'] ?? '',
      optionD: map['OptionD'] ?? '',
      correctAnswer: map['CorrectAnswer'] ?? '',
      explanation: map['Explanation'] ?? '',
      difficulty: map['Difficulty'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'QuestionID': questionID,
      'QuizID': quizID,
      'Question': question,
      'OptionA': optionA,
      'OptionB': optionB,
      'OptionC': optionC,
      'OptionD': optionD,
      'CorrectAnswer': correctAnswer,
      'Explanation': explanation,
      'Difficulty': difficulty,
    };
  }

  List<String> get options => [optionA, optionB, optionC, optionD];
}

class QuizResultModel {
  final int? resultID;
  final int? quizID;
  final int score;
  final int totalQuestions;
  final DateTime dateTaken;
  final int timeSpentSeconds;

  QuizResultModel({
    this.resultID,
    this.quizID,
    required this.score,
    required this.totalQuestions,
    required this.dateTaken,
    required this.timeSpentSeconds,
  });

  factory QuizResultModel.fromMap(Map<String, dynamic> map) {
    return QuizResultModel(
      resultID: map['ResultID'],
      quizID: map['QuizID'],
      score: map['Score'] ?? 0,
      totalQuestions: map['TotalQuestions'] ?? 0,
      dateTaken: DateTime.parse(map['DateTaken']),
      timeSpentSeconds: map['TimeSpentSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ResultID': resultID,
      'QuizID': quizID,
      'Score': score,
      'TotalQuestions': totalQuestions,
      'DateTaken': dateTaken.toIso8601String(),
      'TimeSpentSeconds': timeSpentSeconds,
    };
  }

  double get percentage => (score / totalQuestions) * 100;
  String get formattedTime {
    final minutes = timeSpentSeconds ~/ 60;
    final seconds = timeSpentSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
