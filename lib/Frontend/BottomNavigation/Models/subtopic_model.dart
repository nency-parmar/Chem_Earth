class Subtopic {
  final int id;
  final int topicId;
  final String name;
  final String remarks;
  final String details;

  Subtopic({
    required this.id,
    required this.topicId,
    required this.name,
    required this.remarks,
    required this.details,
  });

  factory Subtopic.fromJson(Map<String, dynamic> json) {
    return Subtopic(
      id: json['id'] ?? 0,
      topicId: json['topic_id'] ?? 0,
      name: json['subtopic_name'] ?? '',
      remarks: json['remarks'] ?? '',
      details: json['details'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_id': topicId,
      'subtopic_name': name,
      'remarks': remarks,
      'details': details,
    };
  }
}
