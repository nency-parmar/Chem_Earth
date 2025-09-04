import 'package:get/get.dart';
import 'package:chem_earth_app/utils/import_export.dart';

class FormulaController extends GetxController {
  final RxString _searchQuery = ''.obs;
  final RxList<FormulaModel> _formulas = <FormulaModel>[].obs;

  String get searchQuery => _searchQuery.value;
  List<FormulaModel> get formulas => _formulas;

  List<FormulaModel> get filteredFormulas {
    final query = _searchQuery.value.toLowerCase();
    return _formulas.where((formula) {
      return formula.symbol.toLowerCase().contains(query) ||
          formula.name.toLowerCase().contains(query) ||
          formula.description.toLowerCase().contains(query) ||
          formula.uses.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchFormulasFromDB();
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void fetchFormulasFromDB() async {
    try {
      final dbHelper = DatabaseHelper();
      final formulasFromDb = await dbHelper.getAllFormulas(); // Must return List<FormulaModel>
      _formulas.assignAll(formulasFromDb);
    } catch (e) {
      print("Error fetching formulas: $e");
    }
  }
}