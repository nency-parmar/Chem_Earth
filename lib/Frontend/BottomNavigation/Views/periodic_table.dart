import 'package:chem_earth_app/utils/import_export.dart';

class PeriodicTable extends StatefulWidget {
  const PeriodicTable({super.key});

  @override
  State<PeriodicTable> createState() => _PeriodicTableState();
}

class _PeriodicTableState extends State<PeriodicTable>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isGridView = true;
  bool isLoading = true;
  String searchQuery = '';
  List<ElementModel> allElements = [];
  List<ElementModel> filteredElements = [];
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Alkali Metal',
    'Alkaline Earth Metal',
    'Transition Metal',
    'Post-Transition Metal',
    'Metalloid',
    'Nonmetal',
    'Halogen',
    'Noble Gas',
    'Lanthanide',
    'Actinide',
  ];

  // Updated category color map with better contrast
  final Map<String, Color> categoryColors = {
    'Alkali Metal': const Color(0xFFE53E3E),
    'Alkaline Earth Metal': const Color(0xFF38A169),
    'Transition Metal': const Color(0xFF3182CE),
    'Post-Transition Metal': const Color(0xFF805AD5),
    'Metalloid': const Color(0xFFD69E2E),
    'Nonmetal': const Color(0xFF00B5D8),
    'Halogen': const Color(0xFF319795),
    'Noble Gas': const Color(0xFF9F7AEA),
    'Lanthanide': const Color(0xFFE53E3E),
    'Actinide': const Color(0xFFD53F8C),
    'Other': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadElements();
    _animationController.forward();
  }

  void _loadElements() {
    // Use the comprehensive elements data
    allElements = PeriodicElementsData.allElements;
    filteredElements = List.from(allElements);
    setState(() {
      isLoading = false;
    });
  }

  void _filterElements() {
    setState(() {
      filteredElements = allElements.where((element) {
        final matchesSearch = element.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            element.symbol.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory =
            selectedCategory == 'All' || element.category == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _sortElements(String sortBy) {
    setState(() {
      switch (sortBy) {
        case 'atomic_number':
          filteredElements.sort((a, b) => a.atomicNumber.compareTo(b.atomicNumber));
          break;
        case 'name':
          filteredElements.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'mass':
          filteredElements.sort((a, b) => a.atomicMass.compareTo(b.atomicMass));
          break;
      }
    });
    
    Get.snackbar(
      'Sorted',
      'Elements sorted by ${_getSortDisplayName(sortBy)}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
      colorText: Get.isDarkMode ? Colors.white : Colors.black,
    );
  }

  String _getSortDisplayName(String sortBy) {
    switch (sortBy) {
      case 'atomic_number': return 'atomic number';
      case 'name': return 'name';
      case 'mass': return 'atomic mass';
      default: return sortBy;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Periodic Table',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.blueGrey[900] : Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          // Sort button
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Elements',
            onSelected: (String value) {
              _sortElements(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'atomic_number',
                child: Row(
                  children: [
                    Icon(Icons.numbers, size: 20),
                    SizedBox(width: 8),
                    Text('Atomic Number'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.abc, size: 20),
                    SizedBox(width: 8),
                    Text('Name (A-Z)'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'mass',
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, size: 20),
                    SizedBox(width: 8),
                    Text('Atomic Mass'),
                  ],
                ),
              ),
            ],
          ),
          // View toggle button
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            tooltip: isGridView ? 'Switch to List View' : 'Switch to Grid View',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.blueGrey.shade50, Colors.white],
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
                child: Column(
                  children: [
                    // Search and Filter Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Search bar
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              onChanged: (value) {
                                searchQuery = value;
                                _filterElements();
                              },
                              decoration: InputDecoration(
                                hintText: 'Search Elements...',
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.blueGrey),
                                suffixIcon: const Icon(Icons.mic,
                                    color: Colors.blueGrey),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Category filter
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final isSelected = selectedCategory == category;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(category),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedCategory = category;
                                      });
                                      _filterElements();
                                    },
                                    selectedColor:
                                        Colors.blueGrey.withOpacity(0.3),
                                    backgroundColor: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.blueGrey
                                          : (isDark
                                              ? Colors.white
                                              : Colors.black),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Elements count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.science,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${filteredElements.length} elements found',
                            style: TextStyle(
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Elements display
                    Expanded(
                      child: isGridView
                          ? _buildGridView(screenSize, isDark)
                          : _buildListView(isDark),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGridView(Size screenSize, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: filteredElements.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenSize.width > 800
              ? 6
              : screenSize.width > 600
                  ? 4
                  : 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return _buildElementCard(filteredElements[index], index, isDark, true);
        },
      ),
    );
  }

  Widget _buildListView(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredElements.length,
      itemBuilder: (context, index) {
        return _buildElementListTile(filteredElements[index], index, isDark);
      },
    );
  }

  Widget _buildElementCard(
      ElementModel element, int index, bool isDark, bool isGrid) {
    final category = element.category;
    final cardColor = categoryColors[category] ?? categoryColors['Other']!;

    // Use opaque colors in light mode, semi-transparent in dark mode
    final useOpaqueCardColor = !isDark;
    final cardBackgroundGradient = LinearGradient(
      colors: [
        useOpaqueCardColor ? cardColor : cardColor.withOpacity(0.8),
        useOpaqueCardColor ? cardColor : cardColor.withOpacity(0.6),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final cardTextColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 100 + (index * 10)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              gradient: cardBackgroundGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showElementDetails(element),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            element.atomicNumber.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: cardTextColor,
                            ),
                          ),
                          if (element.group != null)
                            Text(
                              'G${element.group}',
                              style: TextStyle(
                                fontSize: 10,
                                color: subTextColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                element.symbol,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: cardTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                element.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cardTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        element.atomicMass.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 10,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildElementListTile(ElementModel element, int index, bool isDark) {
    final category = element.category;
    final cardColor = categoryColors[category] ?? categoryColors['Other']!;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 100 + (index * 10)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: cardColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cardColor.withOpacity(0.8),
                        cardColor.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        element.symbol,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        element.atomicNumber.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  element.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${element.category} • Period ${element.period}',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Mass: ${element.atomicMass.toStringAsFixed(3)} u',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[500] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: cardColor,
                  size: 16,
                ),
                onTap: () => _showElementDetails(element),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showElementDetails(ElementModel element) {
    final category = element.category;
    final cardColor = categoryColors[category] ?? categoryColors['Other']!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cardColor.withOpacity(0.8),
                              cardColor.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              element.symbol,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              element.atomicNumber.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              element.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              element.category,
                              style: TextStyle(
                                fontSize: 16,
                                color: cardColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Properties
                  _buildPropertySection('Basic Properties', [
                    _buildProperty('Atomic Mass',
                        '${element.atomicMass.toStringAsFixed(3)} u'),
                    _buildProperty('Period', element.period.toString()),
                    if (element.group != null)
                      _buildProperty('Group', element.group.toString()),
                    _buildProperty('Electron Configuration',
                        element.electronConfiguration),
                  ]),
                  if (element.electronegativity != null ||
                      element.meltingPoint != null ||
                      element.boilingPoint != null ||
                      element.density != null)
                    _buildPropertySection('Physical Properties', [
                      if (element.electronegativity != null)
                        _buildProperty('Electronegativity',
                            element.electronegativity.toString()),
                      if (element.meltingPoint != null)
                        _buildProperty('Melting Point',
                            '${element.meltingPoint!.toStringAsFixed(1)}°C'),
                      if (element.boilingPoint != null)
                        _buildProperty('Boiling Point',
                            '${element.boilingPoint!.toStringAsFixed(1)}°C'),
                      if (element.density != null)
                        _buildProperty('Density',
                            '${element.density!.toStringAsFixed(3)} g/cm³'),
                    ]),
                  _buildPropertySection('Description', [
                    Text(
                      element.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Get.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertySection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProperty(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}