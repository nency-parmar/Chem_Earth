class FormulaModel {
  final int? formulaID;
  final int? subTopicID;
  final String symbol;
  final String name;
  final String molWeight;
  final String description;
  final String uses;
  final String bond;

  FormulaModel({
    this.formulaID,
    this.subTopicID,
    required this.symbol,
    required this.name,
    required this.molWeight,
    required this.description,
    required this.uses,
    required this.bond,
  });

  factory FormulaModel.fromMap(Map<String, dynamic> map) {
    return FormulaModel(
      formulaID: map['FormulaID'],
      subTopicID: map['SubTopicID'],
      symbol: map['Symbol'] ?? '',
      name: map['Name'] ?? '',
      molWeight: map['MolWeight'] ?? '',
      description: map['Description'] ?? '',
      uses: map['Uses'] ?? '',
      bond: map['Bond'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FormulaID': formulaID,
      'SubTopicID': subTopicID,
      'Symbol': symbol,
      'Name': name,
      'MolWeight': molWeight,
      'Description': description,
      'Uses': uses,
      'Bond': bond,
    };
  }

  // Getter methods for backward compatibility
  String get formula => symbol;
  String get topicDescription => name;
  String get remarks => description;
  String get descTable => uses;
}
