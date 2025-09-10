import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chem_earth_app/utils/import_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database with sample data
  final dbHelper = DatabaseHelper();
  await dbHelper.initializeSampleData();

  // Initialize controllers
  Get.put(FormulaController());
  Get.put(QuizController());
  Get.put(ThemeController()); // Register ThemeController globally

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: 'ChemEarth App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blueGrey,
              secondary: Colors.tealAccent,
            ),
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: themeController.themeMode, // <-- Uses controller
          home: const SplashScreen(),
        );
      },
    );
  }
}