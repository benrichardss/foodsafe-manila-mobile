import 'package:flutter/material.dart';
import '../services/session.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onProfileTap;
  const HomeScreen({super.key, required this.onProfileTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = Session.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Header(
                onTap: widget.onProfileTap,
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
