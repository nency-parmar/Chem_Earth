import 'package:chem_earth_app/utils/import_export.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SubTopicDetailsPage extends StatefulWidget {
  final Map<String, dynamic> subTopic;

  const SubTopicDetailsPage({super.key, required this.subTopic});

  @override
  State<SubTopicDetailsPage> createState() => _SubTopicDetailsPageState();
}

class _SubTopicDetailsPageState extends State<SubTopicDetailsPage> {
  Map<String, dynamic>? subTopicDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubTopicDetails();
  }

  Future<void> _loadSubTopicDetails() async {
    try {
      final String response =
      await rootBundle.loadString('assets/database/subtopics.json');

      final List<Map<String, dynamic>> data =
      (json.decode(response) as List).cast<Map<String, dynamic>>();

      final subTopicId = widget.subTopic['id'] ?? widget.subTopic['SubTopicID'];

      final detail = data.firstWhere(
            (item) => item['id'].toString() == subTopicId.toString(),
        orElse: () => {},
      );

      setState(() {
        subTopicDetail = detail.isNotEmpty ? detail : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading subtopic details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subTopic['subtopic_name'] ?? "Details"),
        backgroundColor: isDark ? Colors.blueGrey[900] : Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subTopicDetail == null
          ? const Center(child: Text("No details found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              subTopicDetail?['subtopic_name'] ?? "Untitled",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // Details / Remarks fallback
            Text(
              subTopicDetail?['details'] ??
                  widget.subTopic['remarks'] ??
                  "No description available.",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),

            const SizedBox(height: 20),

            // Examples Section
            if (subTopicDetail?['examples'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Examples",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(
                    (subTopicDetail?['examples'] as List).length,
                        (index) => Padding(
                      padding:
                      const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "- ${subTopicDetail?['examples'][index]}",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
