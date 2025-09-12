import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Add this import
import 'dart:convert';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  bool isLoading = false;

  Future<void> _submitFeedback() async {
    setState(() => isLoading = true);

    final url = Uri.parse('http://api.aswdc.in/Api/MST_AppVersions/PostAppFeedback/AppPostFeedback');
    final Map<String, String> body = {
      'AppName': 'ChemEarth',
      'VersionNo': '1.0',
      'Platform': 'iOS', // or 'iOS'
      'PersonName': nameController.text,
      'Mobile': mobileController.text,
      'Email': emailController.text,
      'Message': feedbackController.text,
      'Remarks': '',
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'API_KEY': '1234', // Pass API_KEY as header
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      final data = json.decode(response.body);
      if (data['IsResult'] == 1) {
        Get.snackbar(
          "Success",
          "Your feedback has been submitted!",
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.blueGrey.shade100,
          colorText: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
        );
        _clearFields();
      } else {
        Get.snackbar(
          "Failed",
          data['Message'] ?? "Submission failed",
          backgroundColor: Colors.red.shade200,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Network error occurred. Try again.",
        backgroundColor: Colors.red.shade200,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgGradient = isDark
        ? [Colors.grey.shade900, Colors.grey.shade800]
        : [Colors.blueGrey.shade50, Colors.white];
    final fieldColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final iconColor = isDark ? Colors.white70 : Colors.blueGrey;
    final textColor = isDark ? Colors.white : Colors.black87;
    final buttonTextColor = isDark ? Colors.black87 : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.blueGrey,
        foregroundColor: theme.appBarTheme.foregroundColor ?? Colors.white,
        elevation: 4,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: nameController,
                  label: "Name",
                  icon: Icons.person,
                  fillColor: fieldColor,
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: mobileController,
                  label: "Mobile Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  fillColor: fieldColor,
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.mail,
                  keyboardType: TextInputType.emailAddress,
                  fillColor: fieldColor,
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: feedbackController,
                  label: "Feedback",
                  icon: Icons.feedback,
                  maxLines: 5,
                  fillColor: fieldColor,
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isDark ? Colors.teal.shade400 : Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            _submitFeedback();
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : Text(
                          "Send",
                          style: TextStyle(fontSize: 16, color: buttonTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: isLoading ? null : _clearFields,
                        child: Text(
                          "Clear",
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required Color fillColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: textColor),
      validator: (value) =>
      value == null || value.isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
        labelText: label,
        labelStyle: TextStyle(color: iconColor),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _clearFields() {
    nameController.clear();
    mobileController.clear();
    emailController.clear();
    feedbackController.clear();
  }
}
