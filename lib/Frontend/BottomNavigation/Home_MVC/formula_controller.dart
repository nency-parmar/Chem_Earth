import 'package:get/get.dart';
import 'formula_model.dart';

class FormulaController extends GetxController {
  final selectedFormula = Rxn<FormulaModel>();

  void setSelectedFormula(FormulaModel formula) {
    selectedFormula.value = formula;
  }
}
