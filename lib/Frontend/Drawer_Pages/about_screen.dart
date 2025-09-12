import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
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
        child: SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 App Logo + Title
                  Center(
                    child: Column(
                      children: [
                        // 🔹 Version Info

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueGrey,
                                Colors.blueGrey.shade700
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.science,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "ChemEarth App",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: color.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: color.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border:
                        Border.all(color: color.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        "Version 1.0.0",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: color.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 🔹 Description
                  _buildDescriptionCard(isDark, theme),

                  const SizedBox(height: 32),



                  // 🔹 Features
                  Text(
                    "Features:",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    Icons.calculate,
                    "Chemical Formulas",
                    "Explore a comprehensive database of chemical compounds",
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    Icons.book,
                    "Topics",
                    "Learn chemistry concepts with detailed explanations",
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    Icons.table_chart,
                    "Periodic Table",
                    "Interactive periodic table with element details",
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    Icons.quiz,
                    "Quiz Section",
                    "Test your chemistry knowledge with fun quizzes",
                    isDark,
                  ),

                  const SizedBox(height: 32),

                  _buildInfoCard(
                    context,
                    "Meet Our Team",
                    [
                      _buildInfoRow("Developed By", "Nency Parmar"),
                      _buildInfoRow("Mentor", "Prof. Mehul Bhundiya"),
                      _buildInfoRow("Explored By", "Nency"),
                      _buildInfoRow("Contact No", "9033190716"),
                      _buildInfoRow("App Title", "ChemEarth"),
                      _buildInfoRow("Share Message", "This is Chemistry App"),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 🔹 Partners
                  Text(
                    "Partners:",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  _buildPartnersCard(context),

                  const SizedBox(height: 30),

// 🔹 Contact Information Card (moved above app actions)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                    child: Card(
                      elevation: 2,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.mail),
                              title: const Text("aswdc@darshan.ac.in"),
                              onTap: () {
                                sendMail(mail: "aswdc@darshan.ac.in");
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: const Text("+91 97277 47310"),
                              onTap: () {
                                dialer(phoneno: "+919727747310");
                              },
                            ),
                            ListTile(
                              leading: const Icon(CupertinoIcons.globe),
                              title: const Text("www.darshan.ac.in"),
                              onTap: () {
                                goToWebsite(website: "https://www.darshan.ac.in");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

// 🔹 App Actions Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Card(
                      elevation: 2,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text("Share App"),
                              onTap: () {
                                Share.share("This is Chemistry App");
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.apps),
                              title: const Text("More Apps"),
                              onTap: () {
                                String url;
                                if (Platform.isIOS) {
                                  url =
                                  "https://apps.apple.com/uz/developer/g-sanghani/id772995906?see-all=i-phone-apps";
                                } else {
                                  url =
                                  "https://play.google.com/store/apps/developer?id=Darshan+University";
                                }
                                launchUrl(Uri.parse(url));
                              },
                            ),
                            ListTile(
                              leading: const Icon(CupertinoIcons.star),
                              title: const Text("Rate Us"),
                              onTap: () {
                                launchUrl(Uri.parse(
                                    "https://play.google.com/store/apps/details?id=com.example.chem_earth_app"));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.thumb_up),
                              title: const Text("Like on Facebook"),
                              onTap: () {
                                launchUrl(Uri.parse(
                                    "https://www.facebook.com/DarshanInstitute.Official"));
                              },
                            ),
                            ListTile(
                              leading: const Icon(CupertinoIcons.arrow_2_circlepath),
                              title: const Text("Check for Updates"),
                              onTap: () {
                                launchUrl(Uri.parse(
                                    "https://play.google.com/store/apps/details?id=com.example.chem_earth_app"));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

// 🔹 Footer
                  _buildFooter(context),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Info Card
  Widget _buildInfoCard(BuildContext context, String title, List<Widget> rows) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Description
  Widget _buildDescriptionCard(bool isDark, ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border:
        isDark ? Border.all(color: Colors.grey.shade700, width: 1) : null,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Text(
        "ChemEarth is a simple and educational app that helps users explore chemical formulas and understand their uses, structures, and fun facts! Whether you're a student or a curious mind, ChemEarth is designed to make chemistry more interactive and enjoyable.",
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          fontSize: 16,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  // 🔹 Feature Card
  Widget _buildFeatureCard(
      IconData icon, String title, String description, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
            isDark ? Colors.blueGrey.shade700 : Colors.blueGrey.shade100,
            child: Icon(icon,
                color: isDark ? Colors.white : Colors.blueGrey.shade800),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "$title\n$description",
              style: TextStyle(
                color: isDark ? Colors.grey.shade200 : Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Partners Card
  Widget _buildPartnersCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Image.asset(
                  isDark
                      ? "assets/images/du_white.png"
                      : "assets/images/DU_Original.jpeg",
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Image.asset(
                  isDark
                      ? "assets/images/aswdc_transparent.png"
                      : "assets/images/aswdc_black.jpeg",
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "ASWDC is Application, Software and Website Development Center @ Darshan University run by Students and Staff of School Of Computer Science.\n\n"
                "Sole purpose of ASWDC is to bridge the gap between university curriculum & industry demands. "
                "Students learn cutting-edge technologies, develop real-world applications & experience a professional environment @ ASWDC under the guidance of industry experts & faculty members.\n\n"
                "Darshan University and ASWDC are our proud partners in making ChemEarth more interactive and student-friendly.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Footer
  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copyright,
                  size: 14, color: isDark ? Colors.grey.shade400 : Colors.grey),
              const SizedBox(width: 4),
              Text(
                '2025 Darshan University',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'All rights reserved - ',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Made with ",
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const Icon(Icons.favorite, color: Colors.red),
              Text(
                " by Nency Parmar",
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Utility methods
  void sendMail({required String mail}) async {
    final Uri uri = Uri(scheme: "mailto", path: mail);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not send mail to $mail";
    }
  }

  void dialer({required String phoneno}) async {
    final Uri uri = Uri(scheme: "tel", path: phoneno);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not dial $phoneno";
    }
  }

  void goToWebsite({required String website}) async {
    final Uri uri = Uri.parse(website);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $website";
    }
  }
}