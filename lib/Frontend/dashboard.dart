import 'package:chem_earth_app/utils/import_export.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    HomeScreen(),
    const PeriodicTable(),
    QuizTopicSelectionScreen(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isDesktop = screenSize.width > 900;
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: isDesktop ? null : Drawer(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.05, 
                  horizontal: screenSize.width * 0.05
                ),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: screenSize.width * 0.08,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        "assets/images/logowithouttext.png",
                        fit: BoxFit.contain,
                        width: screenSize.width * 0.12,
                        height: screenSize.width * 0.12,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome to ChemEarth!",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildDrawerTile(Icons.home, 'Home', () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    }),
                    _buildDrawerTile(Icons.info_outline, 'About', () {
                      Get.to(() => AboutScreen());
                    }),
                    _buildDrawerTile(Icons.school, 'Topics', () {
                      Get.to(() => TopicsPage());
                    }),
                    _buildDrawerTile(Icons.perm_contact_cal_rounded, 'Contact', () {
                      Get.to(() => ContactScreen());
                    }),
                    _buildDrawerTile(Icons.groups_rounded, 'Our Team', () {
                      Get.to(() => TeamScreen());
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.blueGrey[50],
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.blueGrey),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'ChemEarth',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
              "assets/images/logowithouttext.png",
              height: 86,
              width: 86,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _pages[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_rounded),
              label: 'Table',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_sharp),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_suggest_sharp),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDrawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 4,
      ),
    );
  }
}
