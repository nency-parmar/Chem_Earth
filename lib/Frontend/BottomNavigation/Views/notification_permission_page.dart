import 'package:chem_earth_app/utils/import_export.dart';

class NotificationPermissionPage extends StatelessWidget {
  const NotificationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = Get.find<PermissionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Permission',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          Obx(() => controller.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.refreshPermissions,
                  tooltip: 'Refresh permissions',
                )),
        ],
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
                children: [
                  // Header section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueGrey, Colors.blueGrey.shade700],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 60,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Notification Access',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Get updates and reminders about your learning',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Permission status card
                  Obx(() => _buildStatusCard(
                        'Current Status',
                        controller.notificationStatusText,
                        controller.isNotificationGranted,
                        Icons.info_outline,
                        isDark,
                        theme,
                      )),
                  const SizedBox(height: 20),

                  // Permission toggle card
                  Obx(() => _buildPermissionToggleCard(
                        controller,
                        isDark,
                        theme,
                      )),
                  const SizedBox(height: 20),

                  // Features card
                  _buildFeaturesCard(isDark, theme),
                  const SizedBox(height: 20),

                  // Instructions card
                  _buildInstructionsCard(isDark, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String status,
    bool isGranted,
    IconData icon,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
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
        border: isDark ? Border.all(color: Colors.grey.shade700, width: 1) : null,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isGranted ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isGranted ? Colors.green : Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (isGranted ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isGranted ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionToggleCard(
    PermissionController controller,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
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
        border: isDark ? Border.all(color: Colors.grey.shade700, width: 1) : null,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Permission Control',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          
          if (controller.notificationPermissionStatus == PermissionStatus.permanentlyDenied)
            // Permanently denied - show settings button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Permission Permanently Denied',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please enable notification access in app settings',
                    style: TextStyle(color: Colors.orange.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: controller.openAppSettings,
                    icon: const Icon(Icons.settings),
                    label: const Text('Open Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            // Request permission button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.requestNotificationPermission,
                icon: Icon(
                  controller.isNotificationGranted ? Icons.check : Icons.notifications,
                ),
                label: Text(
                  controller.isNotificationGranted 
                      ? 'Permission Granted' 
                      : 'Request Permission',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isNotificationGranted 
                      ? Colors.green 
                      : Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard(bool isDark, ThemeData theme) {
    final features = [
      'Quiz completion notifications',
      'Study reminders and daily goals',
      'New content and feature updates',
      'Achievement and progress alerts',
    ];

    return Container(
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
        border: isDark ? Border.all(color: Colors.grey.shade700, width: 1) : null,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.featured_play_list,
                  color: Colors.blueGrey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Features Available',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard(bool isDark, ThemeData theme) {
    return Container(
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
        border: isDark ? Border.all(color: Colors.grey.shade700, width: 1) : null,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Colors.blueGrey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'How to Use',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            '1.',
            'Tap the \"Request Permission\" button above',
            isDark,
            theme,
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
            '2.',
            'Allow notification access in the system dialog',
            isDark,
            theme,
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
            '3.',
            'Receive helpful notifications about your learning',
            isDark,
            theme,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: You can customize notification types in your device settings.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade700,
                      fontStyle: FontStyle.italic,
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

  Widget _buildInstructionStep(
    String stepNumber,
    String instruction,
    bool isDark,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
