import 'package:chem_earth_app/utils/import_export.dart';

class FormulaDetailsScreen extends StatelessWidget {
  final FormulaDetailsController controller = Get.put(FormulaDetailsController());

  FormulaDetailsScreen({
    super.key,
    required String formula,
    required String topicDescription,
    required String remarks,
    required String descTable,
  }) {
    controller.setDetails(
      formula: formula,
      topicDescription: topicDescription,
      remarks: remarks,
      descTable: descTable,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.topicDescription,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.blueGrey.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: ListView(
              children: [
                // Formula header card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueGrey, Colors.blueGrey.shade700],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.science,
                        size: 40,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.formula,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.topicDescription,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Remarks section
                _buildInfoSection(
                  'Remarks',
                  controller.remarks,
                  Icons.lightbulb_outline,
                  isDark,
                  theme,
                ),
                const SizedBox(height: 20),
                
                // Description/Uses section
                _buildInfoSection(
                  'Description / Uses',
                  controller.descTable,
                  Icons.description_outlined,
                  isDark,
                  theme,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoSection(String title, String content, IconData icon, bool isDark, ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.3) 
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: isDark 
            ? Border.all(color: Colors.grey.shade700, width: 1)
            : null,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.blueGrey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              height: 1.6,
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}