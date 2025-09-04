import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/element_model.dart';

class ElementDetailScreen extends StatelessWidget {
  final ElementModel element;

  const ElementDetailScreen({
    super.key,
    required this.element,
  });

  Color _getCategoryColor(String category) {
    final Map<String, Color> categoryColors = {
      'Alkali Metal': const Color(0xFF81241E),
      'Alkaline Earth Metal': const Color(0xFF577821),
      'Transition Metal': const Color(0xFF066569),
      'Post-Transition Metal': const Color(0xFF0A4D4F),
      'Metalloid': const Color(0xFF9A7A00),
      'Nonmetal': const Color(0xFF015165),
      'Halogen': const Color(0xFF004D40),
      'Noble Gas': const Color(0xFF71216C),
      'Lanthanide': const Color(0xFF77165B),
      'Actinide': const Color(0xFF5A004C),
      'Other': Colors.grey,
    };
    return categoryColors[category] ?? categoryColors['Other']!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;
    final categoryColor = _getCategoryColor(element.category);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        title: Text('${element.name} (${element.symbol})'),
        backgroundColor: categoryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Element Card
            Container(
              width: double.infinity,
              color: categoryColor,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Element Symbol Card
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            element.atomicNumber.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            element.symbol,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),
                          Text(
                            element.atomicMass.toStringAsFixed(3),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      element.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        element.category,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  _buildInfoSection(
                    'Basic Information',
                    Icons.info_outline,
                    [
                      _buildInfoRow('Atomic Number', '${element.atomicNumber}'),
                      _buildInfoRow('Atomic Mass', '${element.atomicMass.toStringAsFixed(3)} u'),
                      _buildInfoRow('Period', '${element.period}'),
                      _buildInfoRow('Group', '${element.group}'),
                      if (element.state != null) _buildInfoRow('State', element.state!),
                      if (element.color != null) _buildInfoRow('Color', element.color!),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Physical Properties
                  _buildInfoSection(
                    'Physical Properties',
                    Icons.science_outlined,
                    [
                      if (element.meltingPoint != null)
                        _buildInfoRow('Melting Point', '${element.meltingPoint}°C'),
                      if (element.boilingPoint != null)
                        _buildInfoRow('Boiling Point', '${element.boilingPoint}°C'),
                      if (element.density != null)
                        _buildInfoRow('Density', '${element.density} g/cm³'),
                      _buildInfoRow('Electron Configuration', element.electronConfiguration),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  _buildDescriptionSection(
                    'Description',
                    Icons.description_outlined,
                    element.description,
                  ),
                  const SizedBox(height: 24),

                  // Properties
                  if (element.properties != null)
                    _buildDescriptionSection(
                      'Properties',
                      Icons.auto_awesome_outlined,
                      element.properties!,
                    ),
                  const SizedBox(height: 24),

                  // Uses
                  if (element.uses != null)
                    _buildDescriptionSection(
                      'Uses & Applications',
                      Icons.build_outlined,
                      element.uses!,
                    ),
                  const SizedBox(height: 24),

                  // Discovery Information
                  _buildInfoSection(
                    'Discovery',
                    Icons.history_outlined,
                    [
                      if (element.discoveredBy != null) _buildInfoRow('Discovered By', element.discoveredBy!),
                      if (element.discoveredYear != null)
                        _buildInfoRow('Discovery Year', '${element.discoveredYear}'),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _getCategoryColor(element.category)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(String title, IconData icon, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _getCategoryColor(element.category)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
