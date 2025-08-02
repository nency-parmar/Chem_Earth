import 'package:chem_earth_app/utils/import_export.dart';

class PeriodicTable extends StatelessWidget {
  const PeriodicTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.blueGrey;

    // Define categories and colors
    final Map<String, Color> categoryColors = {
      'Nonmetal': Colors.blueGrey.shade300,
      'Noble Gas': Colors.purple.shade200,
      'Alkali Metal': Colors.red.shade200,
      'Alkaline Earth Metal': Colors.orange.shade200,
      'Metalloid': Colors.teal.shade200,
      'Halogen': Colors.blue.shade200,
      'Other': Colors.grey.shade300,
    };

    // Dummy list of categorized elements
    final elements = [
      {'symbol': 'H', 'name': 'Hydrogen', 'number': 1, 'category': 'Nonmetal'},
      {'symbol': 'He', 'name': 'Helium', 'number': 2, 'category': 'Noble Gas'},
      {'symbol': 'Li', 'name': 'Lithium', 'number': 3, 'category': 'Alkali Metal'},
      {'symbol': 'Be', 'name': 'Beryllium', 'number': 4, 'category': 'Alkaline Earth Metal'},
      {'symbol': 'B', 'name': 'Boron', 'number': 5, 'category': 'Metalloid'},
      {'symbol': 'C', 'name': 'Carbon', 'number': 6, 'category': 'Nonmetal'},
      {'symbol': 'N', 'name': 'Nitrogen', 'number': 7, 'category': 'Nonmetal'},
      {'symbol': 'O', 'name': 'Oxygen', 'number': 8, 'category': 'Nonmetal'},
      {'symbol': 'F', 'name': 'Fluorine', 'number': 9, 'category': 'Halogen'},
      {'symbol': 'Ne', 'name': 'Neon', 'number': 10, 'category': 'Noble Gas'},
      // Add more with categories
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Periodic Table'),
        backgroundColor: isDark ? Colors.grey[900] : Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: elements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final element = elements[index];
            final category = element['category'] as String;
            final cardColor = categoryColors[category] ?? categoryColors['Other'];

            return GestureDetector(
              onTap: () {
                Get.snackbar(
                  element['symbol'] as String,
                  element['name'] as String,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  colorText: textColor,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        element['symbol'] as String,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        element['number'].toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}