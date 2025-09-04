import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/element_model.dart';
import 'element_data.dart';
import 'element_detail_screen.dart';

class FormulaTableScreen extends StatefulWidget {
  const FormulaTableScreen({super.key});

  @override
  State<FormulaTableScreen> createState() => _FormulaTableScreenState();
}

class _FormulaTableScreenState extends State<FormulaTableScreen> {
  String _searchQuery = '';
  String _sortBy = 'atomicNumber'; // atomicNumber, name, category, discoveredYear
  bool _ascending = true;
  String _filterCategory = 'All';

  List<ElementModel> get _filteredElements {
    List<ElementModel> filtered = elementsList.where((element) {
      final matchesSearch = element.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          element.symbol.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          element.category.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _filterCategory == 'All' || element.category == _filterCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();

    // Sort elements
    filtered.sort((a, b) {
      dynamic valueA, valueB;
      
      switch (_sortBy) {
        case 'name':
          valueA = a.name;
          valueB = b.name;
          break;
        case 'category':
          valueA = a.category;
          valueB = b.category;
          break;
        case 'discoveredYear':
          valueA = a.discoveredYear ?? 0;
          valueB = b.discoveredYear ?? 0;
          break;
        case 'atomicNumber':
        default:
          valueA = a.atomicNumber;
          valueB = b.atomicNumber;
          break;
      }

      if (_ascending) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    });

    return filtered;
  }

  List<String> get _categories {
    final categories = elementsList.map((e) => e.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  Color _getCategoryColor(String category) {
    final Map<String, Color> categoryColors = {
      'Alkali Metal': const Color(0xFF81241E),
      'Alkaline Earth Metal': const Color(0xFF577821),
      'Transition Metal': const Color(0xFF066569),
      'Post-Transition Metal': const Color(0xFF0A4D4F),
      'Metalloid': const Color(0xFF9A7A00),
      'Nonmetal': const Color(0xFF015165),
      'Halogen': const Color(0xFF004D40),
      'Noble Gas': const Color(0xFF71216C),
      'Lanthanide': const Color(0xFF77165B),
      'Actinide': const Color(0xFF5A004C),
      'Other': Colors.grey,
    };
    return categoryColors[category] ?? categoryColors['Other']!;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final filteredElements = _filteredElements;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Formula Table'),
        backgroundColor: isDark ? Colors.blueGrey[900] : Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                if (_sortBy == value) {
                  _ascending = !_ascending;
                } else {
                  _sortBy = value;
                  _ascending = true;
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'atomicNumber',
                child: Row(
                  children: [
                    Icon(Icons.numbers),
                    SizedBox(width: 8),
                    Text('Atomic Number'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.text_fields),
                    SizedBox(width: 8),
                    Text('Name'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'category',
                child: Row(
                  children: [
                    Icon(Icons.category),
                    SizedBox(width: 8),
                    Text('Category'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'discoveredYear',
                child: Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 8),
                    Text('Discovery Year'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? Colors.grey[900] : Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search elements...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                // Category Filter
                Row(
                  children: [
                    const Icon(Icons.filter_list, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _filterCategory,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _filterCategory = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Results Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredElements.length} elements found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_sortBy != 'atomicNumber' || !_ascending)
                  Row(
                    children: [
                      Icon(
                        _ascending ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sorted by ${_sortBy.replaceAll('atomicNumber', 'atomic number')}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Elements List
          Expanded(
            child: filteredElements.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No elements found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filter',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredElements.length,
                    itemBuilder: (context, index) {
                      final element = filteredElements[index];
                      final categoryColor = _getCategoryColor(element.category);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Get.to(
                              () => ElementDetailScreen(element: element),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Element Symbol Circle
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: categoryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        element.atomicNumber.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        element.symbol,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Element Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        element.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: categoryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          element.category,
                                          style: TextStyle(
                                            color: categoryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.science,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Weight: ${element.atomicWeight}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (element.discoveredYear != null) ...[
                                            const SizedBox(width: 16),
                                            Icon(
                                              Icons.history,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${element.discoveredYear}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Arrow Icon
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
