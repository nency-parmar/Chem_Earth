import 'package:get/get.dart';

class FormulaDetailsController extends GetxController {
  late String formula;
  late String topicDescription;
  late String remarks;
  late String descTable;

  void setDetails({
    required String formula,
    required String topicDescription,
    required String remarks,
    required String descTable,
  }) {
    this.formula = formula;
    this.topicDescription = topicDescription;
    this.remarks = remarks;
    this.descTable = descTable;
  }
}