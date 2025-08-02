import 'package:chem_earth_app/utils/import_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // Use global formulas list
    final filteredFormulas = formulaList.where((formula) {
      final query = _searchQuery.toLowerCase();
      return formula.symbol.toLowerCase().contains(query) ||
          formula.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search Formula or Name...',
                  hintStyle: TextStyle(color: theme.hintColor),
                  prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredFormulas.length,
                itemBuilder: (context, index) {
                  final formula = filteredFormulas[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => FormulaDetailsScreen(
                        symbol: formula.symbol,
                        name: formula.name,
                        molWeight: formula.molWeight.toString(),
                        description: formula.description,
                        uses: formula.uses,
                        bond: formula.bond,
                      ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: !isDark
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : [],
                        border: isDark
                            ? Border.all(color: Colors.white12)
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        title: Text(
                          formula.symbol,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          formula.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colorScheme.onSurface.withOpacity(0.4),
                          size: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}