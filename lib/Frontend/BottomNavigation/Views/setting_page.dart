import 'package:chem_earth_app/Frontend/BottomNavigation/Views/feedback_page.dart';
import 'package:chem_earth_app/utils/import_export.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final permissionController = Get.find<PermissionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
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
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Theme Section
            _buildSectionCard(
              'Appearance',
              Icons.palette_outlined,
              [
                Obx(() => SwitchListTile(
                      title: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Switch between light and dark themes',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                        ),
                      ),
                      value: controller.isDarkMode,
                      onChanged: controller.toggleTheme,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.brightness_6,
                          color: Colors.blueGrey,
                        ),
                      ),
                      activeColor: Colors.blueGrey,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    )),
              ],
              isDark,
              theme,
            ),
            const SizedBox(height: 20),

            // Permissions Section
            // _buildSectionCard(
            //   'Permissions',
            //   Icons.security_outlined,
            //   [
            //     Obx(() => _buildPermissionListTile(
            //           Icons.mic_outlined,
            //           'Microphone Access',
            //           'Enable voice search and audio features',
            //           controller.getPermissionStatusText(permissionController.microphonePermissionStatus),
            //           controller.getPermissionStatusColor(permissionController.microphonePermissionStatus),
            //           controller.navigateToMicrophonePermission,
            //           isDark,
            //           theme,
            //         )),
            //     const SizedBox(height: 12),
            //     Obx(() => _buildPermissionListTile(
            //           Icons.notifications_outlined,
            //           'Notification Access',
            //           'Get updates and learning reminders',
            //           controller.getPermissionStatusText(permissionController.notificationPermissionStatus),
            //           controller.getPermissionStatusColor(permissionController.notificationPermissionStatus),
            //           controller.navigateToNotificationPermission,
            //           isDark,
            //           theme,
            //         )),
            //   ],
            //   isDark,
            //   theme,
            // ),
            // const SizedBox(height: 20),

            // About Section
            _buildSectionCard(
              'About',
              Icons.info_outline,
              [
                _buildNavigationListTile(
                  Icons.info_outlined,
                  'About App',
                  'Learn more about ChemEarth',
                  () => Get.to(() => const AboutScreen()),
                  isDark,
                  theme,
                ),
                const SizedBox(height: 12),
                _buildNavigationListTile(
                  Icons.feedback_outlined,
                  'Give Feedback',
                  'Tell us what you think about ChemEarth.',
                      () => Get.to(() => const FeedbackPage()),
                  isDark,
                  theme,
                )
              ],
              isDark,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData titleIcon,
    List<Widget> children,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
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
      padding: const EdgeInsets.all(20.0),
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
                child: Icon(
                  titleIcon,
                  color: Colors.blueGrey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPermissionListTile(
    IconData icon,
    String title,
    String subtitle,
    String status,
    Color statusColor,
    VoidCallback onTap,
    bool isDark,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade700.withValues(alpha: 0.3) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: statusColor,
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
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationListTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    bool isDark,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade700.withValues(alpha: 0.3) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.blueGrey,
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
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}