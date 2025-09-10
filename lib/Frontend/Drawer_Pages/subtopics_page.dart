import 'package:chem_earth_app/utils/import_export.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SubTopicsPage extends StatefulWidget {
  final Map<String, dynamic> topic;

  const SubTopicsPage({super.key, required this.topic});

  @override
  State<SubTopicsPage> createState() => _SubTopicsPageState();
}

class _SubTopicsPageState extends State<SubTopicsPage>
    with SingleTickerProviderStateMixin {
  // ----------------------------
  // Variables
  // ----------------------------
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> subTopics = [];
  bool isLoading = true;

  // ----------------------------
  // Lifecycle
  // ----------------------------
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadSubTopics();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ----------------------------
  // Data Loader
  // ----------------------------
  Future<void> _loadSubTopics() async {
    try {
      final String response =
      await rootBundle.loadString('assets/database/subtopics.json');

      final List<dynamic> data = json.decode(response);

      final topicId = widget.topic['TopicID'] ?? widget.topic['id'];

      final filtered = data
          .where((item) =>
      item['topic_id'].toString() == topicId.toString())
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();

      setState(() {
        subTopics = filtered; // ✅ now it's List<Map<String, dynamic>>
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading subtopics: $e");
    }
  }



  // ----------------------------
  // UI - Build
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topic['TopicName'] ?? 'Subtopics',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.blueGrey[900] : Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.blueGrey.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: () => _navigateToQuiz(),
            tooltip: 'Take Quiz',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          ),
        )
            : FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              _buildHeader(isDark),
              subTopics.isEmpty
                  ? _buildEmptyState()
                  : _buildSubTopicList(isDark),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------
  // UI - Sections
  // ----------------------------
  Widget _buildHeader(bool isDark) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.topic,
                      color: Colors.blueGrey, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Subtopics',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : Colors.blueGrey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.topic['Remarks'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.blueGrey.shade800.withOpacity(0.3)
                    : Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: Colors.blueGrey, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${subTopics.length} subtopics available for learning',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.topic_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No Subtopics Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Subtopics will be loaded from database',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubTopicList(bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final subTopic = subTopics[index];
            return _buildSubTopicCard(subTopic, index, isDark, context);
          },
          childCount: subTopics.length,
        ),
      ),
    );
  }

  // ----------------------------
  // UI - Cards
  // ----------------------------
  Widget _buildSubTopicCard(Map<String, dynamic> subTopic, int index,
      bool isDark, BuildContext context) {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
      Colors.red.shade400,
      Colors.cyan.shade400,
    ];
    final icons = [
      Icons.science,
      Icons.biotech,
      Icons.local_gas_station,
      Icons.psychology,
      Icons.engineering,
      Icons.healing,
      Icons.wb_sunny,
      Icons.water_drop,
    ];

    final color = colors[index % colors.length];
    final icon = icons[index % icons.length];
    final screenSize = MediaQuery.of(context).size;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _onSubTopicTap(subTopic),
                  child: Padding(
                    padding: EdgeInsets.all(screenSize.width < 400 ? 12 : 20),
                    child: Row(
                      children: [
                        _buildLeadingIcon(color, icon),
                        const SizedBox(width: 20),
                        _buildSubTopicInfo(subTopic, isDark, screenSize),
                        _buildTrailingArrow(color),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeadingIcon(Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, size: 32, color: Colors.white),
    );
  }

  Widget _buildSubTopicInfo(
      Map<String, dynamic> subTopic, bool isDark, Size screenSize) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subTopic['subtopic_name'] ?? 'Unknown Subtopic',
            style: TextStyle(
              fontSize: screenSize.width < 400 ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          if (subTopic['remarks'] != null &&
              subTopic['remarks'].toString().isNotEmpty)
            Text(
              subTopic['remarks'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenSize.width < 400 ? 12 : 14,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrailingArrow(Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
    );
  }

  // ----------------------------
  // Actions
  // ----------------------------
  void _onSubTopicTap(Map<String, dynamic> subTopic) {
    final normalizedSubTopic = {
      'id': subTopic['id'] ?? subTopic['SubTopicID'],
      'topic_id': subTopic['topic_id'] ?? subTopic['TopicID'],
      'subtopic_name': subTopic['subtopic_name'] ?? subTopic['SubTopicName'],
      'remarks': subTopic['remarks'] ?? subTopic['Remarks'],
    };

    Get.to(() => SubTopicDetailsPage(subTopic: normalizedSubTopic));
  }


  void _showSubTopicDetails(Map<String, dynamic> subTopic) {
    final isDark = Get.isDarkMode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBottomSheetHeader(subTopic, isDark),
                  const SizedBox(height: 24),
                  _buildBottomSheetAbout(subTopic, isDark),
                  const SizedBox(height: 24),
                  _buildBottomSheetButtons(isDark),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetHeader(Map<String, dynamic> subTopic, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.topic, color: Colors.blueGrey, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            subTopic['subtopic_name'] ?? 'Subtopic Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(
            backgroundColor: Colors.blueGrey.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheetAbout(Map<String, dynamic> subTopic, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.blueGrey.shade800.withOpacity(0.3)
            : Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Subtopic',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subTopic['remarks'] ??
                'This subtopic covers important concepts and detailed explanations of the subject matter.',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Study Materials');
            },
            icon: const Icon(Icons.book),
            label: const Text('Study Materials'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Practice Questions');
            },
            icon: const Icon(Icons.quiz),
            label: const Text('Practice'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              foregroundColor: isDark ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToQuiz() {
    Get.to(() => QuizTopicSelectionScreen());
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      'Coming Soon!',
      '$feature will be available in future updates.',
      backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
      colorText: Get.isDarkMode ? Colors.white : Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
    );
  }
}