import 'package:flutter/material.dart';
import 'package:chem_earth_app/utils/import_export.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App title with icon
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blueGrey, Colors.blueGrey.shade700],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.science,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "ChemEarth App",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: color.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Description card
                  Container(
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
                    child: Text(
                      "ChemEarth is a simple and educational app that helps users explore chemical formulas and understand their uses, structures, and fun facts! Whether you're a student or a curious mind, ChemEarth is designed to make chemistry more interactive and enjoyable.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Features section
                  Text(
                    "Features:",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(Icons.calculate, "Chemical Formulas", "Explore a comprehensive database of chemical compounds", isDark),
                  const SizedBox(height: 12),
                  _buildFeatureCard(Icons.book, "Topics", "Learn chemistry concepts with detailed explanations", isDark),
                  const SizedBox(height: 12),
                  _buildFeatureCard(Icons.table_chart, "Periodic Table", "Interactive periodic table with element details", isDark),
                  const SizedBox(height: 12),
                  _buildFeatureCard(Icons.quiz, "Quiz Section", "Test your chemistry knowledge with fun quizzes", isDark),
                  const SizedBox(height: 40),
                  
                  // Version info
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: color.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        "Version 1.0.0",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: color.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDark 
            ? Border.all(color: Colors.grey.shade700, width: 1)
            : null,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon, 
              color: Colors.blueGrey,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}