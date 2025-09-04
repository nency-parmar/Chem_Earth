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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Our Team",
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
          child: Column(
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.all(24.0),
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
                        Icons.group,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Meet Our Team",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "The passionate individuals behind ChemEarth",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Team members list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: teamMembers.length,
                  itemBuilder: (context, index) {
                    final member = teamMembers[index];
                    return _buildTeamMemberCard(member, isDark, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTeamMemberCard(Map<String, String> member, bool isDark, int index) {
    // Different gradient colors for variety
    final gradientColors = [
      [Colors.blueGrey, Colors.blueGrey.shade700],
      [Colors.teal, Colors.teal.shade700],
      [Colors.indigo, Colors.indigo.shade700],
    ];
    final currentGradient = gradientColors[index % gradientColors.length];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: currentGradient,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: currentGradient[0].withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'] ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  member['role'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: currentGradient[0],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: currentGradient[0].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Team Member",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: currentGradient[0],
                    ),
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