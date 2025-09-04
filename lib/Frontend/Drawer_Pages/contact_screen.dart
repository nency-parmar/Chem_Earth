import 'package:chem_earth_app/utils/import_export.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
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
                  // Header section
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
                            Icons.contact_support,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Reach Out to Us",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: color.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We'd love to hear from you!",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Contact information cards
                  _buildContactCard(
                    Icons.email_outlined,
                    "Email",
                    "support@chemearth.app",
                    "Send us an email for support",
                    isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildContactCard(
                    Icons.phone_outlined,
                    "Phone",
                    "+91 9876543210",
                    "Call us for immediate assistance",
                    isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildContactCard(
                    Icons.language_outlined,
                    "Website",
                    "www.chemearth.app",
                    "Visit our website for more info",
                    isDark,
                  ),
                  const SizedBox(height: 40),
                  
                  // Additional info card
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 32,
                          color: color.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Support Hours",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Monday - Friday: 9:00 AM - 6:00 PM (IST)",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          "We typically respond within 24 hours",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContactCard(IconData icon, String title, String value, String description, bool isDark) {
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
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