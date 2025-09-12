import 'package:flutter/material.dart';
import 'package:aswdc_flutter_pub/aswdc_flutter_pub.dart' as abPage;

class ABpage extends StatelessWidget {
  const ABpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // give height
          width: double.infinity,                     // fill width
          child: abPage.DeveloperScreen(
            developerName: 'Nency Parmar',
            mentorName: 'Nency',
            exploredByName: 'Nency',
            contactNo: '9033190716',
            isAdmissionApp: false,
            shareMessage: 'nncjkwnecjs',
            appTitle: 'ChemEarth',
            appLogo: 'assets/images/DU_Original.jpeg',
          ),
        ),
      ),
    );
  }
}
