import 'package:chem_earth_app/utils/import_export.dart';

class QuizTopicSelectionScreen extends StatelessWidget {
  QuizTopicSelectionScreen({super.key});

  final QuizController quizController = Get.find<QuizController>();

  // Icons for different topics
  final Map<String, IconData> topicIcons = {
    'Atomic Structure': Icons.science_outlined,
    'Chemical Bonding': Icons.link,
    'Periodic Table': Icons.grid_view,
    'States of Matter': Icons.cloud_outlined,
    'Thermodynamics': Icons.thermostat,
    'Chemical Equilibrium': Icons.balance,
    'Acids, Bases & Salts': Icons.water_drop,
    'Organic Chemistry': Icons.eco,
    'Environmental Chemistry': Icons.nature,
    'Electrochemistry': Icons.electric_bolt,
  };

  // Colors for different topics
  final Map<String, Color> topicColors = {
    'Atomic Structure': Colors.blue,
    'Chemical Bonding': Colors.purple,
    'Periodic Table': Colors.green,
    'States of Matter': Colors.cyan,
    'Thermodynamics': Colors.red,
    'Chemical Equilibrium': Colors.orange,
    'Acids, Bases & Salts': Colors.indigo,
    'Organic Chemistry': Colors.teal,
    'Environmental Chemistry': Colors.lightGreen,
    'Electrochemistry': Colors.amber,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Select Quiz Topic",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Obx(() {
        if (quizController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (quizController.quizTopics.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 80,
                  color: colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No quiz topics available',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => quizController.loadQuizTopics(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => quizController.loadQuizTopics(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizController.quizTopics.length,
            itemBuilder: (context, index) {
              final topic = quizController.quizTopics[index];
              final topicIcon = topicIcons[topic.topicName] ?? Icons.quiz;
              final topicColor = topicColors[topic.topicName] ?? Colors.blueGrey;

              return GestureDetector(
                onTap: () {
                  _showQuizOptionsDialog(context, topic);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        topicColor.withOpacity(0.1),
                        topicColor.withOpacity(0.05),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? Colors.white12
                          : topicColor.withOpacity(0.2),
                    ),
                    boxShadow: !isDark
                        ? [
                      BoxShadow(
                        color: topicColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                        : [],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: topicColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        topicIcon,
                        color: topicColor,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      topic.topicName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      topic.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: topicColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: topicColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showQuizOptionsDialog(BuildContext context, QuizTopicModel topic) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          topic.topicName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose number of questions:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [5, 10, 15, 20].map((count) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _startQuiz(topic, count);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('$count'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _startQuiz(QuizTopicModel topic, int questionCount) {
    Get.to(() => QuizScreen(
      topic: topic.topicName,
    ));
  }
}