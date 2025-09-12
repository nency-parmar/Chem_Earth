import 'package:chem_earth_app/utils/import_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FormulaController controller = Get.put(FormulaController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
          child: Column(
            children: [
              // Beautiful header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 14),
                // padding: const EdgeInsets.fromLTRB(left, top, right, bottom),
                child: Column(
                  children: [
                    // App logo and title
                    // Row(
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.all(12),
                    //       decoration: BoxDecoration(
                    //         gradient: LinearGradient(
                    //           colors: [Colors.blueGrey, Colors.blueGrey.shade700],
                    //         ),
                    //         borderRadius: BorderRadius.circular(16),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.blueGrey.withValues(alpha: 0.3),
                    //             blurRadius: 10,
                    //             offset: const Offset(0, 4),
                    //           ),
                    //         ],
                    //       ),
                    //       child: const Icon(
                    //         Icons.science,
                    //         size: 28,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'ChemEarth',
                    //             style: theme.textTheme.headlineMedium?.copyWith(
                    //               fontWeight: FontWeight.bold,
                    //               color: colorScheme.primary,
                    //             ),
                    //           ),
                    //           Text(
                    //             'Explore Chemical Formulas',
                    //             style: theme.textTheme.bodyMedium?.copyWith(
                    //               color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 24),
                    
                    // Enhanced search bar
                    Container(
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
                      child: TextField(
                        onChanged: controller.updateSearchQuery,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search Formula or Topic...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                          ),
                          prefixIcon: Icon(
                            Icons.search, 
                            color: Colors.blueGrey,
                            size: 24,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.mic, size: 20),
                              color: Colors.blueGrey,
                              onPressed: () {
                                // Add your microphone tap logic here
                              },
                            ),
                          ),
                          filled: false,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, 
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Enhanced formulas list
              Expanded(
                child: Obx(() {
                  final filteredFormulas = controller.filteredFormulas;
                  return filteredFormulas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No formulas found',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          itemCount: filteredFormulas.length,
                          itemBuilder: (context, index) {
                            final formula = filteredFormulas[index];
                            return _buildFormulaCard(formula, index, isDark, theme, colorScheme);
                          },
                        );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFormulaCard(dynamic formula, int index, bool isDark, ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FormulaDetailsScreen(
          formula: formula.symbol,
          topicDescription: formula.name,
          remarks: formula.description,
          descTable: formula.uses,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Formula symbol in a styled container
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey, Colors.blueGrey.shade700],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    formula.symbol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              
              // Formula details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formula.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        formula.molWeight,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to explore details',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}