import 'package:chem_earth_app/utils/import_export.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chem_earth.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('CREATE TABLE IF NOT EXISTS MST_Elements (...)');
    }
  }

  Future<void> _createTables(Database db) async {
    // Formula Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_Formula (
        FormulaID INTEGER PRIMARY KEY AUTOINCREMENT,
        SubTopicID INTEGER,
        Symbol TEXT NOT NULL,
        Name TEXT NOT NULL,
        MolWeight TEXT,
        Description TEXT,
        Uses TEXT,
        Bond TEXT
      )
    ''');

    // Topic Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_Topic (
        TopicID INTEGER PRIMARY KEY AUTOINCREMENT,
        TopicName TEXT NOT NULL,
        Remarks TEXT
      )
    ''');

    // SubTopic Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_SubTopic (
        SubTopicID INTEGER PRIMARY KEY AUTOINCREMENT,
        TopicID INTEGER,
        SubTopicName TEXT NOT NULL,
        Remarks TEXT,
        FOREIGN KEY (TopicID) REFERENCES MST_Topic(TopicID)
      )
    ''');

    // Quiz Topics Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_Quiz (
        QuizID INTEGER PRIMARY KEY AUTOINCREMENT,
        TopicName TEXT NOT NULL,
        Description TEXT,
        IconPath TEXT
      )
    ''');

    // Quiz Questions Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_QuizQuestions (
        QuestionID INTEGER PRIMARY KEY AUTOINCREMENT,
        QuizID INTEGER NOT NULL,
        Question TEXT NOT NULL,
        OptionA TEXT NOT NULL,
        OptionB TEXT NOT NULL,
        OptionC TEXT NOT NULL,
        OptionD TEXT NOT NULL,
        CorrectAnswer TEXT NOT NULL,
        Explanation TEXT,
        Difficulty TEXT DEFAULT 'Medium',
        FOREIGN KEY (QuizID) REFERENCES MST_Quiz(QuizID)
      )
    ''');

    // Quiz Results Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_QuizResults (
        ResultID INTEGER PRIMARY KEY AUTOINCREMENT,
        QuizID INTEGER NOT NULL,
        Score INTEGER NOT NULL,
        TotalQuestions INTEGER NOT NULL,
        DateTaken TEXT NOT NULL,
        TimeSpentSeconds INTEGER NOT NULL,
        FOREIGN KEY (QuizID) REFERENCES MST_Quiz(QuizID)
      )
    ''');

    // Mole Table (for future use)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_Mole (
        MolecularID INTEGER PRIMARY KEY AUTOINCREMENT,
        SubTopicID INTEGER,
        SubTopicName TEXT,
        Remarks TEXT,
        IsFavourite INTEGER DEFAULT 0,
        SubTopicDisplayName TEXT,
        IsMolecularFavourite INTEGER DEFAULT 0
      )
    ''');

    // Molecular Table (for future use)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_Molecular (
        MolecularID INTEGER PRIMARY KEY AUTOINCREMENT,
        MolecularName TEXT,
        MolecularFormula TEXT,
        Description TEXT,
        Remarks TEXT
      )
    ''');

    // Elements Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MST_Elements (
        AtomicNumber INTEGER PRIMARY KEY,
        Symbol TEXT NOT NULL,
        Name TEXT NOT NULL,
        Category TEXT NOT NULL,
        AtomicMass REAL NOT NULL,
        ElectronConfiguration TEXT NOT NULL,
        Period INTEGER NOT NULL,
        GroupNumber INTEGER,
        Description TEXT NOT NULL,
        Electronegativity REAL,
        MeltingPoint REAL,
        BoilingPoint REAL,
        Density REAL,
        Uses TEXT,
        Properties TEXT,
        DiscoveredBy TEXT,
        DiscoveredYear INTEGER,
        State TEXT,
        Color TEXT
      )
    ''');
  }

  // Get Method of Formulas
  Future<List<FormulaModel>> getAllFormulas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('MST_Formula');

    return maps.map((map) => FormulaModel.fromMap(map)).toList();
  }

  // Post Method of Formulas
  Future<void> insertSampleFormulas() async {
    final db = await database;

    for (final formula in formulaList) {
      await db.insert(
        'MST_Formula',
        formula.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Insert Sample Topics and SubTopics
  Future<void> insertSampleTopics() async {
    final db = await database;

    // Check if topics already exist
    final existingTopics = await db.query('MST_Topic');
    if (existingTopics.isNotEmpty) return;

    List<Map<String, dynamic>> topics = [
      {"TopicName": "Basic Chemistry", "Remarks": "Fundamental concepts and principles of chemistry"},
      {"TopicName": "Atomic Structure", "Remarks": "Structure of atoms, subatomic particles, and electron configuration"},
      {"TopicName": "Chemical Bonding", "Remarks": "Types of chemical bonds and their properties"},
      {"TopicName": "Periodic Table", "Remarks": "Organization and trends in the periodic table"},
      {"TopicName": "States of Matter", "Remarks": "Properties of solids, liquids, and gases"},
      {"TopicName": "Chemical Reactions", "Remarks": "Types of reactions and reaction mechanisms"},
      {"TopicName": "Acids, Bases & Salts", "Remarks": "Properties and behavior of acids, bases, and salts"},
      {"TopicName": "Organic Chemistry", "Remarks": "Study of carbon-based compounds"},
      {"TopicName": "Inorganic Chemistry", "Remarks": "Study of non-organic compounds"},
      {"TopicName": "Physical Chemistry", "Remarks": "Physical properties and behavior of matter"},
      {"TopicName": "Thermodynamics", "Remarks": "Energy changes in chemical reactions"},
      {"TopicName": "Electrochemistry", "Remarks": "Chemical processes involving electricity"},
    ];

    for (var topic in topics) {
      await db.insert('MST_Topic', topic);
    }

    // Insert SubTopics
    await insertSampleSubTopics();
  }

  // Insert comprehensive subtopics
  Future<void> insertSampleSubTopics() async {
    final db = await database;

    // Check if subtopics already exist
    final existingSubTopics = await db.query('MST_SubTopic');
    if (existingSubTopics.isNotEmpty) return;

    List<Map<String, dynamic>> subTopics = [
      // Basic Chemistry (TopicID: 1)
      {"TopicID": 1, "SubTopicName": "Introduction to Chemistry", "Remarks": "What is chemistry and its importance"},
      {"TopicID": 1, "SubTopicName": "Matter and Energy", "Remarks": "Properties of matter and forms of energy"},
      {"TopicID": 1, "SubTopicName": "Measurement and Units", "Remarks": "Scientific measurement systems and units"},
      {"TopicID": 1, "SubTopicName": "Scientific Method", "Remarks": "Steps of scientific investigation"},
      
      // Atomic Structure (TopicID: 2)
      {"TopicID": 2, "SubTopicName": "Subatomic Particles", "Remarks": "Protons, neutrons, and electrons"},
      {"TopicID": 2, "SubTopicName": "Atomic Models", "Remarks": "Evolution of atomic theory"},
      {"TopicID": 2, "SubTopicName": "Electron Configuration", "Remarks": "Arrangement of electrons in atoms"},
      {"TopicID": 2, "SubTopicName": "Quantum Numbers", "Remarks": "Describing electron positions and properties"},
      
      // Chemical Bonding (TopicID: 3)
      {"TopicID": 3, "SubTopicName": "Ionic Bonding", "Remarks": "Formation and properties of ionic bonds"},
      {"TopicID": 3, "SubTopicName": "Covalent Bonding", "Remarks": "Formation and properties of covalent bonds"},
      {"TopicID": 3, "SubTopicName": "Metallic Bonding", "Remarks": "Properties of metallic bonds"},
      {"TopicID": 3, "SubTopicName": "Intermolecular Forces", "Remarks": "Forces between molecules"},
      
      // Periodic Table (TopicID: 4)
      {"TopicID": 4, "SubTopicName": "Periodic Law", "Remarks": "Organization principles of the periodic table"},
      {"TopicID": 4, "SubTopicName": "Periodic Trends", "Remarks": "Trends in atomic properties"},
      {"TopicID": 4, "SubTopicName": "Element Groups", "Remarks": "Properties of element families"},
      {"TopicID": 4, "SubTopicName": "Transition Elements", "Remarks": "Properties of transition metals"},
      
      // States of Matter (TopicID: 5)
      {"TopicID": 5, "SubTopicName": "Kinetic Molecular Theory", "Remarks": "Theory explaining behavior of gases"},
      {"TopicID": 5, "SubTopicName": "Gas Laws", "Remarks": "Mathematical relationships for gases"},
      {"TopicID": 5, "SubTopicName": "Liquids and Solids", "Remarks": "Properties of condensed phases"},
      {"TopicID": 5, "SubTopicName": "Phase Changes", "Remarks": "Transitions between states of matter"},
      
      // Chemical Reactions (TopicID: 6)
      {"TopicID": 6, "SubTopicName": "Types of Reactions", "Remarks": "Classification of chemical reactions"},
      {"TopicID": 6, "SubTopicName": "Stoichiometry", "Remarks": "Quantitative relationships in reactions"},
      {"TopicID": 6, "SubTopicName": "Reaction Rates", "Remarks": "Factors affecting reaction speed"},
      {"TopicID": 6, "SubTopicName": "Chemical Equilibrium", "Remarks": "Dynamic balance in reactions"},
      
      // Acids, Bases & Salts (TopicID: 7)
      {"TopicID": 7, "SubTopicName": "Acid-Base Theories", "Remarks": "Different definitions of acids and bases"},
      {"TopicID": 7, "SubTopicName": "pH and pOH", "Remarks": "Measuring acidity and basicity"},
      {"TopicID": 7, "SubTopicName": "Neutralization", "Remarks": "Reactions between acids and bases"},
      {"TopicID": 7, "SubTopicName": "Buffer Solutions", "Remarks": "Solutions that resist pH changes"},
      
      // Organic Chemistry (TopicID: 8)
      {"TopicID": 8, "SubTopicName": "Hydrocarbons", "Remarks": "Compounds containing only carbon and hydrogen"},
      {"TopicID": 8, "SubTopicName": "Functional Groups", "Remarks": "Common organic molecular groups"},
      {"TopicID": 8, "SubTopicName": "Isomerism", "Remarks": "Different arrangements of same molecular formula"},
      {"TopicID": 8, "SubTopicName": "Organic Reactions", "Remarks": "Common reactions in organic chemistry"},
      
      // Inorganic Chemistry (TopicID: 9)
      {"TopicID": 9, "SubTopicName": "Coordination Compounds", "Remarks": "Complex ions and coordination chemistry"},
      {"TopicID": 9, "SubTopicName": "Metallurgy", "Remarks": "Extraction and purification of metals"},
      {"TopicID": 9, "SubTopicName": "Non-metals", "Remarks": "Properties and compounds of non-metals"},
      {"TopicID": 9, "SubTopicName": "Industrial Chemistry", "Remarks": "Large-scale chemical processes"},
      
      // Physical Chemistry (TopicID: 10)
      {"TopicID": 10, "SubTopicName": "Chemical Kinetics", "Remarks": "Study of reaction rates and mechanisms"},
      {"TopicID": 10, "SubTopicName": "Surface Chemistry", "Remarks": "Phenomena at surfaces and interfaces"},
      {"TopicID": 10, "SubTopicName": "Solutions", "Remarks": "Properties of mixtures and solutions"},
      {"TopicID": 10, "SubTopicName": "Colligative Properties", "Remarks": "Properties that depend on particle concentration"},
      
      // Thermodynamics (TopicID: 11)
      {"TopicID": 11, "SubTopicName": "First Law of Thermodynamics", "Remarks": "Conservation of energy principle"},
      {"TopicID": 11, "SubTopicName": "Enthalpy", "Remarks": "Heat content of systems"},
      {"TopicID": 11, "SubTopicName": "Entropy", "Remarks": "Measure of disorder in systems"},
      {"TopicID": 11, "SubTopicName": "Gibbs Free Energy", "Remarks": "Energy available to do work"},
      
      // Electrochemistry (TopicID: 12)
      {"TopicID": 12, "SubTopicName": "Redox Reactions", "Remarks": "Reactions involving electron transfer"},
      {"TopicID": 12, "SubTopicName": "Electrochemical Cells", "Remarks": "Galvanic and electrolytic cells"},
      {"TopicID": 12, "SubTopicName": "Electrolysis", "Remarks": "Decomposition using electrical energy"},
      {"TopicID": 12, "SubTopicName": "Corrosion", "Remarks": "Degradation of metals through oxidation"},
    ];

    for (var subTopic in subTopics) {
      await db.insert('MST_SubTopic', subTopic);
    }
  }

  // Insert Sample Quiz Topics with comprehensive data
  Future<void> insertSampleQuizTopics() async {
    final db = await database;

    // Check if quiz topics already exist
    final existingQuizTopics = await db.query('MST_Quiz');
    if (existingQuizTopics.isNotEmpty) return;

    List<Map<String, dynamic>> quizTopics = [
      {"TopicName": "Atomic Structure", "Description": "Basics of atoms, subatomic particles, and electron configuration"},
      {"TopicName": "Chemical Bonding", "Description": "Ionic, covalent, and metallic bonds with their properties"},
      {"TopicName": "Periodic Table", "Description": "Elements classification, trends, and periodic properties"},
      {"TopicName": "States of Matter", "Description": "Solid, liquid, gas properties and phase transitions"},
      {"TopicName": "Thermodynamics", "Description": "Heat, work, energy concepts, and chemical thermodynamics"},
      {"TopicName": "Chemical Equilibrium", "Description": "Chemical and ionic equilibria, Le Chatelier's principle"},
      {"TopicName": "Acids, Bases & Salts", "Description": "pH, pOH, titration, buffer solutions, and neutralization"},
      {"TopicName": "Organic Chemistry", "Description": "Hydrocarbons, functional groups, and organic reactions"},
      {"TopicName": "Environmental Chemistry", "Description": "Pollution, ozone layer, greenhouse effect, and green chemistry"},
      {"TopicName": "Electrochemistry", "Description": "Redox reactions, electrochemical cells, and electrolysis"},
    ];

    for (var topic in quizTopics) {
      await db.insert(
        'MST_Quiz',
        topic,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Insert Sample Quiz Questions
  Future<void> insertSampleQuizQuestions() async {
    final db = await database;

    // Check if questions already exist
    final existingQuestions = await db.query('MST_QuizQuestions');
    if (existingQuestions.isNotEmpty) return;

    List<Map<String, dynamic>> questions = [
      // Atomic Structure Questions (QuizID: 1)
      {
        "QuizID": 1,
        "Question": "What is the maximum number of electrons that can be held in the second electron shell?",
        "OptionA": "2",
        "OptionB": "8",
        "OptionC": "18",
        "OptionD": "32",
        "CorrectAnswer": "B",
        "Explanation": "The second electron shell can hold a maximum of 8 electrons (2s² + 2p⁶).",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 1,
        "Question": "Which subatomic particle has a negative charge?",
        "OptionA": "Proton",
        "OptionB": "Neutron",
        "OptionC": "Electron",
        "OptionD": "Alpha particle",
        "CorrectAnswer": "C",
        "Explanation": "Electrons have a negative charge (-1), while protons have a positive charge (+1) and neutrons are neutral.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 1,
        "Question": "What determines the identity of an element?",
        "OptionA": "Number of electrons",
        "OptionB": "Number of neutrons",
        "OptionC": "Number of protons",
        "OptionD": "Atomic mass",
        "CorrectAnswer": "C",
        "Explanation": "The number of protons (atomic number) uniquely identifies an element.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 1,
        "Question": "Which orbital can hold a maximum of 2 electrons?",
        "OptionA": "s orbital",
        "OptionB": "p orbital",
        "OptionC": "d orbital",
        "OptionD": "f orbital",
        "CorrectAnswer": "A",
        "Explanation": "An s orbital can hold a maximum of 2 electrons with opposite spins.",
        "Difficulty": "Medium"
      },
      {
        "QuizID": 1,
        "Question": "What is the electron configuration of nitrogen (N, atomic number 7)?",
        "OptionA": "1s² 2s² 2p³",
        "OptionB": "1s² 2s² 2p⁵",
        "OptionC": "1s² 2s³ 2p²",
        "OptionD": "1s² 2s¹ 2p⁴",
        "CorrectAnswer": "A",
        "Explanation": "Nitrogen has 7 electrons arranged as 1s² 2s² 2p³.",
        "Difficulty": "Medium"
      },
      
      // Chemical Bonding Questions (QuizID: 2)
      {
        "QuizID": 2,
        "Question": "What type of bond is formed between sodium and chlorine in NaCl?",
        "OptionA": "Covalent bond",
        "OptionB": "Ionic bond",
        "OptionC": "Metallic bond",
        "OptionD": "Hydrogen bond",
        "CorrectAnswer": "B",
        "Explanation": "Sodium (metal) loses an electron to chlorine (non-metal), forming an ionic bond.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 2,
        "Question": "Which molecule has a covalent bond?",
        "OptionA": "NaCl",
        "OptionB": "MgO",
        "OptionC": "H₂O",
        "OptionD": "CaF₂",
        "CorrectAnswer": "C",
        "Explanation": "Water (H₂O) is formed by covalent bonds between hydrogen and oxygen atoms.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 2,
        "Question": "What happens to electrons in a covalent bond?",
        "OptionA": "They are transferred completely",
        "OptionB": "They are shared between atoms",
        "OptionC": "They are lost from both atoms",
        "OptionD": "They become delocalized",
        "CorrectAnswer": "B",
        "Explanation": "In covalent bonding, electrons are shared between atoms to achieve stability.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 2,
        "Question": "Which type of bond is present in metals?",
        "OptionA": "Ionic bond",
        "OptionB": "Covalent bond",
        "OptionC": "Metallic bond",
        "OptionD": "Hydrogen bond",
        "CorrectAnswer": "C",
        "Explanation": "Metallic bonding involves a 'sea of electrons' that are delocalized among metal atoms.",
        "Difficulty": "Medium"
      },
      {
        "QuizID": 2,
        "Question": "What is the molecular geometry of methane (CH₄)?",
        "OptionA": "Linear",
        "OptionB": "Trigonal planar",
        "OptionC": "Tetrahedral",
        "OptionD": "Bent",
        "CorrectAnswer": "C",
        "Explanation": "Methane has a tetrahedral geometry with bond angles of 109.5°.",
        "Difficulty": "Medium"
      },
      
      // Periodic Table Questions (QuizID: 3)
      {
        "QuizID": 3,
        "Question": "Which element has the atomic number 6?",
        "OptionA": "Oxygen",
        "OptionB": "Carbon",
        "OptionC": "Nitrogen",
        "OptionD": "Boron",
        "CorrectAnswer": "B",
        "Explanation": "Carbon has 6 protons in its nucleus, giving it an atomic number of 6.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 3,
        "Question": "What is the most reactive metal in the periodic table?",
        "OptionA": "Lithium",
        "OptionB": "Sodium",
        "OptionC": "Potassium",
        "OptionD": "Francium",
        "CorrectAnswer": "D",
        "Explanation": "Francium is the most reactive metal as it's at the bottom of Group 1 (alkali metals).",
        "Difficulty": "Medium"
      },
      {
        "QuizID": 3,
        "Question": "Which group contains the noble gases?",
        "OptionA": "Group 1",
        "OptionB": "Group 17",
        "OptionC": "Group 18",
        "OptionD": "Group 2",
        "CorrectAnswer": "C",
        "Explanation": "Group 18 contains the noble gases (helium, neon, argon, etc.).",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 3,
        "Question": "As you go down a group in the periodic table, what happens to atomic radius?",
        "OptionA": "Increases",
        "OptionB": "Decreases",
        "OptionC": "Stays the same",
        "OptionD": "Fluctuates randomly",
        "CorrectAnswer": "A",
        "Explanation": "Atomic radius increases down a group due to additional electron shells.",
        "Difficulty": "Medium"
      },
      {
        "QuizID": 3,
        "Question": "Which element has the highest electronegativity?",
        "OptionA": "Oxygen",
        "OptionB": "Nitrogen",
        "OptionC": "Fluorine",
        "OptionD": "Chlorine",
        "CorrectAnswer": "C",
        "Explanation": "Fluorine has the highest electronegativity value of 4.0 on the Pauling scale.",
        "Difficulty": "Medium"
      },
      
      // States of Matter Questions (QuizID: 4)
      {
        "QuizID": 4,
        "Question": "At what temperature does water freeze at standard pressure?",
        "OptionA": "0°C",
        "OptionB": "100°C",
        "OptionC": "-273°C",
        "OptionD": "32°C",
        "CorrectAnswer": "A",
        "Explanation": "Water freezes at 0°C (32°F) at standard atmospheric pressure.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 4,
        "Question": "Which state of matter has definite volume but no definite shape?",
        "OptionA": "Solid",
        "OptionB": "Liquid",
        "OptionC": "Gas",
        "OptionD": "Plasma",
        "CorrectAnswer": "B",
        "Explanation": "Liquids have definite volume but take the shape of their container.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 4,
        "Question": "What happens to the kinetic energy of particles when temperature increases?",
        "OptionA": "Decreases",
        "OptionB": "Stays the same",
        "OptionC": "Increases",
        "OptionD": "Becomes zero",
        "CorrectAnswer": "C",
        "Explanation": "Higher temperature means particles have more kinetic energy and move faster.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 4,
        "Question": "According to Boyle's Law, what happens to pressure when volume decreases?",
        "OptionA": "Pressure decreases",
        "OptionB": "Pressure increases",
        "OptionC": "Pressure stays constant",
        "OptionD": "Pressure becomes zero",
        "CorrectAnswer": "B",
        "Explanation": "Boyle's Law states that pressure and volume are inversely proportional at constant temperature.",
        "Difficulty": "Medium"
      },
      {
        "QuizID": 4,
        "Question": "What is sublimation?",
        "OptionA": "Solid to liquid",
        "OptionB": "Liquid to gas",
        "OptionC": "Solid to gas",
        "OptionD": "Gas to liquid",
        "CorrectAnswer": "C",
        "Explanation": "Sublimation is the direct transition from solid to gas phase without melting.",
        "Difficulty": "Medium"
      },
      
      // Thermodynamics Questions (QuizID: 5)
      {
        "QuizID": 5,
        "Question": "What does the First Law of Thermodynamics state?",
        "OptionA": "Energy cannot be created or destroyed",
        "OptionB": "Entropy always increases",
        "OptionC": "Heat flows from cold to hot",
        "OptionD": "Work equals heat",
        "CorrectAnswer": "A",
        "Explanation": "The First Law states that energy is conserved - it cannot be created or destroyed.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 5,
        "Question": "An exothermic reaction:",
        "OptionA": "Absorbs heat",
        "OptionB": "Releases heat",
        "OptionC": "Has no heat change",
        "OptionD": "Only occurs at high temperature",
        "CorrectAnswer": "B",
        "Explanation": "Exothermic reactions release heat to the surroundings, making them feel warm.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 5,
        "Question": "What is entropy?",
        "OptionA": "Total energy of a system",
        "OptionB": "Measure of disorder",
        "OptionC": "Heat capacity",
        "OptionD": "Reaction rate",
        "CorrectAnswer": "B",
        "Explanation": "Entropy is a measure of the disorder or randomness in a system.",
        "Difficulty": "Medium"
      },
      {
        "QuizID": 5,
        "Question": "What is the standard unit for enthalpy?",
        "OptionA": "Joules",
        "OptionB": "Calories",
        "OptionC": "kJ/mol",
        "OptionD": "Watts",
        "CorrectAnswer": "C",
        "Explanation": "Enthalpy is typically measured in kJ/mol (kilojoules per mole).",
        "Difficulty": "Medium"
      },
      
      // Chemical Equilibrium Questions (QuizID: 6)
      {
        "QuizID": 6,
        "Question": "What happens when a system at equilibrium is disturbed?",
        "OptionA": "It stops reacting",
        "OptionB": "It shifts to counteract the change",
        "OptionC": "It explodes",
        "OptionD": "Nothing happens",
        "CorrectAnswer": "B",
        "Explanation": "Le Chatelier's principle states that equilibrium shifts to counteract disturbances.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 6,
        "Question": "At equilibrium, the rate of forward reaction is:",
        "OptionA": "Greater than reverse reaction",
        "OptionB": "Less than reverse reaction",
        "OptionC": "Equal to reverse reaction",
        "OptionD": "Zero",
        "CorrectAnswer": "C",
        "Explanation": "At equilibrium, forward and reverse reaction rates are equal.",
        "Difficulty": "Easy"
      },
      
      // Acids, Bases & Salts Questions (QuizID: 7)
      {
        "QuizID": 7,
        "Question": "What is the pH of pure water at 25°C?",
        "OptionA": "0",
        "OptionB": "7",
        "OptionC": "14",
        "OptionD": "1",
        "CorrectAnswer": "B",
        "Explanation": "Pure water has a pH of 7, which is neutral (neither acidic nor basic).",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 7,
        "Question": "Which of the following is a strong acid?",
        "OptionA": "Acetic acid (CH₃COOH)",
        "OptionB": "Carbonic acid (H₂CO₃)",
        "OptionC": "Hydrochloric acid (HCl)",
        "OptionD": "Citric acid",
        "CorrectAnswer": "C",
        "Explanation": "Hydrochloric acid (HCl) is a strong acid that completely dissociates in water.",
        "Difficulty": "Medium"
      },
      {
        "QuizID": 7,
        "Question": "What is produced when an acid reacts with a base?",
        "OptionA": "Salt and water",
        "OptionB": "Only salt",
        "OptionC": "Only water",
        "OptionD": "Gas and heat",
        "CorrectAnswer": "A",
        "Explanation": "Acid-base neutralization produces salt and water.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 7,
        "Question": "What is the pH range for acids?",
        "OptionA": "0-7",
        "OptionB": "7-14",
        "OptionC": "0-14",
        "OptionD": "1-6",
        "CorrectAnswer": "A",
        "Explanation": "Acids have pH values less than 7 (0-6.99).",
        "Difficulty": "Easy"
      },
      
      // Organic Chemistry Questions (QuizID: 8)
      {
        "QuizID": 8,
        "Question": "What is the simplest hydrocarbon?",
        "OptionA": "Ethane",
        "OptionB": "Methane",
        "OptionC": "Propane",
        "OptionD": "Butane",
        "CorrectAnswer": "B",
        "Explanation": "Methane (CH₄) is the simplest hydrocarbon with one carbon atom.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 8,
        "Question": "Which functional group is present in alcohols?",
        "OptionA": "-COOH",
        "OptionB": "-CHO",
        "OptionC": "-OH",
        "OptionD": "-NH₂",
        "CorrectAnswer": "C",
        "Explanation": "Alcohols contain the hydroxyl (-OH) functional group.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 8,
        "Question": "What type of bond is present in alkenes?",
        "OptionA": "Single bond",
        "OptionB": "Double bond",
        "OptionC": "Triple bond",
        "OptionD": "Aromatic bond",
        "CorrectAnswer": "B",
        "Explanation": "Alkenes contain at least one C=C double bond.",
        "Difficulty": "Easy"
      },
      
      // Environmental Chemistry Questions (QuizID: 9)
      {
        "QuizID": 9,
        "Question": "Which gas is primarily responsible for the greenhouse effect?",
        "OptionA": "Oxygen",
        "OptionB": "Nitrogen",
        "OptionC": "Carbon dioxide",
        "OptionD": "Argon",
        "CorrectAnswer": "C",
        "Explanation": "Carbon dioxide is the main greenhouse gas contributing to global warming.",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 9,
        "Question": "What destroys the ozone layer?",
        "OptionA": "Carbon dioxide",
        "OptionB": "Chlorofluorocarbons (CFCs)",
        "OptionC": "Methane",
        "OptionD": "Water vapor",
        "CorrectAnswer": "B",
        "Explanation": "CFCs release chlorine atoms that catalytically destroy ozone molecules.",
        "Difficulty": "Medium"
      },
      
      // Electrochemistry Questions (QuizID: 10)
      {
        "QuizID": 10,
        "Question": "In a redox reaction, what happens to the oxidized substance?",
        "OptionA": "Gains electrons",
        "OptionB": "Loses electrons",
        "OptionC": "Gains protons",
        "OptionD": "Loses protons",
        "CorrectAnswer": "B",
        "Explanation": "Oxidation is the loss of electrons (OIL - Oxidation Is Loss).",
        "Difficulty": "Easy"
      },
      {
        "QuizID": 10,
        "Question": "What is the purpose of a salt bridge in an electrochemical cell?",
        "OptionA": "To generate electricity",
        "OptionB": "To maintain electrical neutrality",
        "OptionC": "To speed up reactions",
        "OptionD": "To prevent corrosion",
        "CorrectAnswer": "B",
        "Explanation": "Salt bridges maintain electrical neutrality by allowing ion flow between half-cells.",
        "Difficulty": "Medium"
      },
    ];

    for (var question in questions) {
      await db.insert(
        'MST_QuizQuestions',
        question,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Initialize all sample data
  Future<void> initializeSampleData() async {
    await insertSampleTopics();
    await insertSampleFormulas();
    await insertSampleQuizTopics();
    await insertSampleQuizQuestions();
    await insertSampleElements();
  }

  // Get All Quiz Topics
  Future<List<Map<String, dynamic>>> getAllQuizTopics() async {
    final db = await database;
    return await db.query('MST_Quiz');
  }

  // Get Quiz Questions by Topic ID
  Future<List<Map<String, dynamic>>> getQuizQuestions(int quizID, {int? limit}) async {
    final db = await database;
    String query = 'SELECT * FROM MST_QuizQuestions WHERE QuizID = ?';
    List<dynamic> args = [quizID];

    if (limit != null) {
      query += ' ORDER BY RANDOM() LIMIT ?';
      args.add(limit);
    } else {
      query += ' ORDER BY RANDOM()';
    }

    return await db.rawQuery(query, args);
  }

  // Save Quiz Result
  Future<void> saveQuizResult(QuizResultModel result) async {
    final db = await database;
    await db.insert(
      'MST_QuizResults',
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Quiz Results
  Future<List<Map<String, dynamic>>> getQuizResults({int? quizID}) async {
    final db = await database;
    if (quizID != null) {
      return await db.query(
        'MST_QuizResults',
        where: 'QuizID = ?',
        whereArgs: [quizID],
        orderBy: 'DateTaken DESC',
      );
    } else {
      return await db.query(
        'MST_QuizResults',
        orderBy: 'DateTaken DESC',
      );
    }
  }

  // Get Topics
  Future<List<Map<String, dynamic>>> getAllTopics() async {
    final db = await database;
    return await db.query('MST_Topic');
  }

  // Get SubTopics by Topic ID
  Future<List<Map<String, dynamic>>> getSubTopics(int topicID) async {
    final db = await database;
    return await db.query(
      'MST_SubTopic',
      where: 'TopicID = ?',
      whereArgs: [topicID],
    );
  }

  // Add new formula
  Future<void> addFormula(FormulaModel formula) async {
    final db = await database;
    await db.insert(
      'MST_Formula',
      formula.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update formula
  Future<void> updateFormula(FormulaModel formula) async {
    final db = await database;
    await db.update(
      'MST_Formula',
      formula.toMap(),
      where: 'FormulaID = ?',
      whereArgs: [formula.formulaID],
    );
  }

  // Delete formula
  Future<void> deleteFormula(int formulaID) async {
    final db = await database;
    await db.delete(
      'MST_Formula',
      where: 'FormulaID = ?',
      whereArgs: [formulaID],
    );
  }

  // Search formulas
  Future<List<FormulaModel>> searchFormulas(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM MST_Formula 
      WHERE Symbol LIKE ? OR Name LIKE ? OR Description LIKE ? OR Uses LIKE ?
    ''', ['%$query%', '%$query%', '%$query%', '%$query%']);

    return maps.map((map) => FormulaModel.fromMap(map)).toList();
  }

  // Elements Database Methods
  Future<void> insertSampleElements() async {
    final db = await database;
    
    try {
      // Check if elements already exist
      final existingElements = await db.query('MST_Elements');
      if (existingElements.isNotEmpty) return;
    } catch (e) {
      // Table might not exist yet, continue with insertion
    }

    // Insert all elements from PeriodicElementsData
    for (final element in PeriodicElementsData.allElements) {
      try {
        await db.insert(
          'MST_Elements',
          {
            'AtomicNumber': element.atomicNumber,
            'Symbol': element.symbol,
            'Name': element.name,
            'Category': element.category,
            'AtomicMass': element.atomicMass,
            'ElectronConfiguration': element.electronConfiguration,
            'Period': element.period,
            'GroupNumber': element.group,
            'Description': element.description,
            'Electronegativity': element.electronegativity,
            'MeltingPoint': element.meltingPoint,
            'BoilingPoint': element.boilingPoint,
            'Density': element.density,
            'Uses': element.uses,
            'Properties': element.properties,
            'DiscoveredBy': element.discoveredBy,
            'DiscoveredYear': element.discoveredYear,
            'State': element.state,
            'Color': element.color,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        // Skip this element if there's an error
        continue;
      }
    }
  }

  // Get all elements from database
  Future<List<ElementModel>> getAllElements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'MST_Elements', 
      orderBy: 'AtomicNumber ASC'
    );

    return maps.map((map) => ElementModel.fromMap(map)).toList();
  }

  // Get element by atomic number
  Future<ElementModel?> getElementById(int atomicNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'MST_Elements',
      where: 'AtomicNumber = ?',
      whereArgs: [atomicNumber],
    );

    if (maps.isEmpty) return null;
    return ElementModel.fromMap(maps.first);
  }

  // Search elements
  Future<List<ElementModel>> searchElements(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM MST_Elements 
      WHERE Symbol LIKE ? OR Name LIKE ? OR Category LIKE ? OR Description LIKE ?
      ORDER BY AtomicNumber ASC
    ''', ['%$query%', '%$query%', '%$query%', '%$query%']);

    return maps.map((map) => ElementModel.fromMap(map)).toList();
  }

  // Get elements by category
  Future<List<ElementModel>> getElementsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'MST_Elements',
      where: 'Category = ?',
      whereArgs: [category],
      orderBy: 'AtomicNumber ASC',
    );

    return maps.map((map) => ElementModel.fromMap(map)).toList();
  }

  // Update element
  Future<void> updateElement(ElementModel element) async {
    final db = await database;
    await db.update(
      'MST_Elements',
      element.toMap(),
      where: 'AtomicNumber = ?',
      whereArgs: [element.atomicNumber],
    );
  }
}