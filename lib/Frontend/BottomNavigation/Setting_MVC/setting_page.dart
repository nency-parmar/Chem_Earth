import 'package:chem_earth_app/utils/import_export.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Dark Mode Toggle
          Obx(() => SwitchListTile(
            title: const Text('Dark Mode'),
            value: controller.isDarkMode.value,
            onChanged: controller.toggleTheme,
            secondary: const Icon(Icons.brightness_6),
          )),

          const Divider(),

          // Language Dropdown
          Obx(() => ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: controller.selectedLanguage.value.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                DropdownMenuItem(value: 'gu', child: Text('Gujarati')),
              ],
              onChanged: controller.changeLanguage,
            ),
          )),

          const Divider(),

          // Permission Handler Section (UI only)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Permissions", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.mic),
            title: const Text("Microphone Access"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Just UI; actual logic can be added later
              Get.snackbar("Info", "Microphone Settings Tapped!!!",
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notification Access"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar("Info", "Notification Settings Tapped!!",
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),

          const Divider(),

          // About, Contact, Team
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            onTap: () => Get.to(() => const AboutScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.perm_contact_cal_rounded),
            title: const Text('Contact Us'),
            onTap: () => Get.to(() => const ContactScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Our Team'),
            onTap: () => Get.to(() => const TeamScreen()),
          ),
        ],
      ),
    );
  }
}