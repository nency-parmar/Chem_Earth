class ElementModel {
  final int atomicNumber;
  final String symbol;
  final String name;
  final String category;
  final double atomicMass;
  final String electronConfiguration;
  final int period;
  final int? group; // Some elements like lanthanides don't have groups
  final String description;
  final double? electronegativity;
  final double? meltingPoint; // in Celsius
  final double? boilingPoint; // in Celsius
  final double? density; // g/cm³
  
  // Optional fields for backward compatibility
  final String? uses;
  final String? properties;
  final String? discoveredBy;
  final int? discoveredYear;
  final String? state;
  final String? color;
  final double? atomicWeight;

  ElementModel({
    required this.atomicNumber,
    required this.symbol,
    required this.name,
    required this.category,
    required this.atomicMass,
    required this.electronConfiguration,
    required this.period,
    required this.group,
    required this.description,
    this.electronegativity,
    this.meltingPoint,
    this.boilingPoint,
    this.density,
    this.uses,
    this.properties,
    this.discoveredBy,
    this.discoveredYear,
    this.state,
    this.color,
    this.atomicWeight,
  });

  factory ElementModel.fromMap(Map<String, dynamic> map) {
    return ElementModel(
      atomicNumber: map['AtomicNumber'] ?? 0,
      symbol: map['Symbol'] ?? '',
      name: map['Name'] ?? '',
      category: map['Category'] ?? '',
      atomicMass: (map['AtomicMass'] ?? 0.0).toDouble(),
      electronConfiguration: map['ElectronConfiguration'] ?? '',
      period: map['Period'] ?? 0,
      group: map['GroupNumber'] ?? map['Group'],
      description: map['Description'] ?? '',
      electronegativity: map['Electronegativity']?.toDouble(),
      meltingPoint: map['MeltingPoint']?.toDouble(),
      boilingPoint: map['BoilingPoint']?.toDouble(),
      density: map['Density']?.toDouble(),
      uses: map['Uses'],
      properties: map['Properties'],
      discoveredBy: map['DiscoveredBy'],
      discoveredYear: map['DiscoveredYear'],
      state: map['State'],
      color: map['Color'],
      atomicWeight: map['atomicWeight'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'AtomicNumber': atomicNumber,
      'Symbol': symbol,
      'Name': name,
      'Category': category,
      'AtomicMass': atomicMass,
      'ElectronConfiguration': electronConfiguration,
      'Period': period,
      'Group': group,
      'Description': description,
      'Electronegativity': electronegativity,
      'MeltingPoint': meltingPoint,
      'BoilingPoint': boilingPoint,
      'Density': density,
      'Uses': uses,
      'Properties': properties,
      'DiscoveredBy': discoveredBy,
      'DiscoveredYear': discoveredYear,
      'State': state,
      'Color': color,
    };
  }
}
