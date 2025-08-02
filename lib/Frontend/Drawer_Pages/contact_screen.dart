import 'package:chem_earth_app/utils/import_export.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: color.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reach Out to Us",
                style: theme.textTheme.headlineSmall?.copyWith(
                    color: color.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.email),
                const SizedBox(width: 10),
                Text("support@chemearth.app",
                    style: theme.textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 10),
                Text("+91 9876543210", style: theme.textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.web),
                const SizedBox(width: 10),
                Text("www.chemearth.app", style: theme.textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}