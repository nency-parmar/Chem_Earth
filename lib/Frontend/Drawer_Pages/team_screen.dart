import 'package:chem_earth_app/utils/import_export.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  final List<Map<String, String>> teamMembers = const [
    {"name": "Nency Parmar", "role": "Developer & Designer"},
    {"name": "Prof. Mehul Bhundiya", "role": "Mentor & Guide"},
    {"name": "Hello", "role": "Tester & Feedback"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Team"),
        backgroundColor: color.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          final member = teamMembers[index];
          return Card(
            color: theme.cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(member['name'] ?? '',
                  style: theme.textTheme.titleMedium),
              subtitle: Text(member['role'] ?? '',
                  style: theme.textTheme.bodyMedium),
            ),
          );
        },
      ),
    );
  }
}