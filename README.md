# ChemEarth - Enhanced Chemistry Learning App 🧪

A comprehensive Flutter application designed to make learning chemistry engaging and interactive. This app features a complete periodic table with all 118 elements, chemistry topics, quizzes, and formula references.

## ✨ Features

### 🔬 Complete Periodic Table
- **All 118 Elements**: Complete data for every element in the periodic table
- **Dual View Modes**: Switch between grid and list view
- **Advanced Search**: Search by name, symbol, or category
- **Smart Filtering**: Filter by element categories (Alkali Metal, Halogen, etc.)
- **Sorting Options**: Sort by atomic number, name, or atomic mass
- **Detailed Information**: Comprehensive element details including physical properties, electron configuration, and descriptions

### 📚 Topics Page
- **Interactive Design**: Beautiful card-based layout matching app theme
- **Database Integration**: Topics loaded from SQLite database
- **Detailed Views**: Modal bottom sheets with topic information
- **Educational Content**: Comprehensive chemistry topics with descriptions

### 🎯 Quiz System
- **10 Chemistry Topics**: Atomic Structure, Chemical Bonding, Periodic Table, and more
- **Interactive Quizzes**: Multiple choice questions with explanations
- **Timer Functionality**: Track time spent on quizzes
- **Score Tracking**: Save and review quiz results
- **Difficulty Levels**: Questions marked as Easy, Medium, or Hard

### 🧮 Formula Reference
- **Chemical Formulas**: Comprehensive database of important chemical compounds
- **Molecular Details**: Molecular weight, bond types, and uses
- **Search Functionality**: Find formulas by name or symbol

### 🎨 Modern Design
- **Material 3 Design**: Modern, responsive UI
- **Dark/Light Theme**: Automatic theme switching
- **Smooth Animations**: Beautiful transitions and loading animations
- **Color-Coded Categories**: Each element category has unique colors

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.0 or higher)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ChemEarth
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Database Initialization
The app automatically initializes the SQLite database with sample data on first run, including:
- All 118 periodic table elements
- Chemistry topics and subtopics
- Quiz questions and answers
- Sample chemical formulas

## 🌟 Recent Enhancements

### What's New in This Version
- ✅ Complete periodic table with all 118 elements
- ✅ Enhanced Topics page with better design and database integration
- ✅ List view option for periodic table with enhanced sorting
- ✅ Advanced filtering by element categories
- ✅ Removed admin panel for cleaner user experience
- ✅ Fixed all compilation errors and database issues
- ✅ Improved color-coded element categories
- ✅ Better responsive design for different screen sizes

## 🎯 App Navigation

### Main Features Access
- **Home Tab**: Browse chemical formulas and compounds
- **Periodic Table Tab**: Complete interactive periodic table
- **Quiz Tab**: Chemistry quizzes and challenges
- **Settings Tab**: App preferences and theme settings

### Drawer Menu
- **About**: Information about the app
- **Topics**: Chemistry topics and learning materials
- **Contact**: Contact information
- **Our Team**: Development team details

## 🛠️ Technical Specifications

### Dependencies
- **Flutter SDK**: ^3.5.0
- **sqflite**: ^2.3.0 (Local database)
- **get**: ^4.6.6 (State management)
- **intl**: ^0.19.0 (Internationalization)

### Database Schema
- **MST_Elements**: All 118 periodic table elements
- **MST_Topic**: Chemistry topics
- **MST_Formula**: Chemical formulas and compounds
- **MST_Quiz**: Quiz topics and questions
- **MST_QuizResults**: Quiz attempt tracking

## 📄 License

This project is licensed under the MIT License.

---

**Built with ❤️ by Nency Parmar**

*Making chemistry education accessible and engaging for everyone.*
