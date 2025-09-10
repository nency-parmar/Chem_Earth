export 'package:flutter/material.dart';
export 'package:get/get.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:sqflite/sqflite.dart';
export 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// Utils
export 'package:chem_earth_app/utils/const.dart';
export 'package:chem_earth_app/utils/theme_controller.dart';

// Backend
export 'package:chem_earth_app/Backend/Database/database_helper.dart';

// Models
export 'package:chem_earth_app/Frontend/BottomNavigation/Models/formula_model.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Models/element_model.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Models/topic_model.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Models/quiz_model.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Models/subtopic_model.dart';

// Controllers
export 'package:chem_earth_app/Frontend/BottomNavigation/Controllers/formula_controller.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Controllers/formula_details_controller.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Controllers/quiz_controller.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Controllers/setting_controller.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Controllers/permission_controller.dart';

// Services
export 'package:chem_earth_app/Frontend/BottomNavigation/Services/permission_service.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Services/subtopic_service.dart';

// Views and Data
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/formula_data.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/element_data.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/periodic_elements_data.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/home_screen.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/periodic_table.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/formula_detail_screen.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/formula_table_screen.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/element_detail_screen.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/setting_page.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/microphone_permission_page.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Views/notification_permission_page.dart';

// Quiz Pages
export 'package:chem_earth_app/Frontend/BottomNavigation/Quiz_Pages/quiz_topic_selection_screen.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Quiz_Pages/quiz_screen.dart';
export 'package:chem_earth_app/Frontend/BottomNavigation/Quiz_Pages/quiz_result_screen.dart';

// Drawer Pages
export 'package:chem_earth_app/Frontend/Drawer_Pages/about_screen.dart';
export 'package:chem_earth_app/Frontend/Drawer_Pages/contact_screen.dart';
export 'package:chem_earth_app/Frontend/Drawer_Pages/team_screen.dart';
export 'package:chem_earth_app/Frontend/Drawer_Pages/topics_page.dart';
export 'package:chem_earth_app/Frontend/Drawer_Pages/subtopics_page.dart';
export 'package:chem_earth_app/Frontend/Drawer_Pages/subtopics_details.dart';


// Main Pages
export 'package:chem_earth_app/Frontend/dashboard.dart';
export 'package:chem_earth_app/splash_screen.dart';
