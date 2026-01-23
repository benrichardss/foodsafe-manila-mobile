import 'package:flutter/material.dart';
import 'package:foodsafe_manila/screens/alerts_screen.dart';

import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Header(
                onBellTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const AlertsScreen(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    children: const [
                      DashboardSummaryCard(),
                      SizedBox(height: 14),
                      CurrentRiskCard(),
                      SizedBox(height: 18),
                      NearbyAlertsSection(),
                      SizedBox(height: 18),
                      HealthTipsSection(),
                      SizedBox(height: 14),
                      EmergencyHotlinesCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
