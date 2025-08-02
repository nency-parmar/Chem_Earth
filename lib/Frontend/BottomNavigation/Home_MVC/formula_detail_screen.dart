import 'package:flutter/material.dart';

class FormulaDetailsScreen extends StatelessWidget {
  final String symbol;
  final String name;
  final String molWeight;
  final String description;
  final String uses;
  final String bond;

  const FormulaDetailsScreen({
    Key? key,
    required this.symbol,
    required this.name,
    required this.molWeight,
    required this.description,
    required this.uses,
    required this.bond,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                symbol,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Name: $name',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Molecular Weight: $molWeight g/mol',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Bond Type: $bond',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.deepPurple,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description:',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Uses / Fun Fact:',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                uses,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}