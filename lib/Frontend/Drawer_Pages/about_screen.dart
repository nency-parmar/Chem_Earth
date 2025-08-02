import 'package:chem_earth_app/utils/import_export.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: color.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ChemEarth App",
                style: theme.textTheme.headlineSmall?.copyWith(
                    color: color.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "ChemEarth is a simple and educational app that helps users explore chemical formulas and understand their uses, structures, and fun facts! Whether you're a student or a curious mind, ChemEarth is designed to make chemistry more interactive and enjoyable.",
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}