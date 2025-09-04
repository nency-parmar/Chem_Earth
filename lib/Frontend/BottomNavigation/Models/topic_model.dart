class TopicModel {
  final int? topicID;
  final String topicName;
  final String remarks;

  TopicModel({
    this.topicID,
    required this.topicName,
    required this.remarks,
  });

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      topicID: map['TopicID'],
      topicName: map['TopicName'] ?? '',
      remarks: map['Remarks'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TopicID': topicID,
      'TopicName': topicName,
      'Remarks': remarks,
    };
  }
}

class SubTopicModel {
  final int? subTopicID;
  final int? topicID;
  final String subTopicName;
  final String remarks;

  SubTopicModel({
    this.subTopicID,
    this.topicID,
    required this.subTopicName,
    required this.remarks,
  });

  factory SubTopicModel.fromMap(Map<String, dynamic> map) {
    return SubTopicModel(
      subTopicID: map['SubTopicID'],
      topicID: map['TopicID'],
      subTopicName: map['SubTopicName'] ?? '',
      remarks: map['Remarks'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SubTopicID': subTopicID,
      'TopicID': topicID,
      'SubTopicName': subTopicName,
      'Remarks': remarks,
    };
  }
}
