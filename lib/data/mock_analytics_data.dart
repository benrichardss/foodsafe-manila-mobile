import 'package:flutter/material.dart';
import '../widgets/analytics_widgets.dart';

class TrendPoint {
  final String label;
  final double value;
  TrendPoint(this.label, this.value);
}

class DistrictData {
  final String name;
  final double value;
  DistrictData(this.name, this.value);
}

class IllnessData {
  final String name;
  final double value;
  final Color color;
  IllnessData(this.name, this.value, this.color);
}

class AnalyticsBundle {
  final List<TrendPoint> trends;
  final List<DistrictData> districts;
  final List<IllnessData> illnesses;
  final int currentCases;
  final double percentChange;

  AnalyticsBundle({
    required this.trends,
    required this.districts,
    required this.illnesses,
    required this.currentCases,
    required this.percentChange,
  });
}

// ===========================
// MOCK DATA BY RANGE
// ===========================

class MockAnalyticsData {
  static AnalyticsBundle getData(TimeRange range) {
    switch (range) {
      case TimeRange.week:
        return _weekData();
      case TimeRange.month:
        return _monthData();
      case TimeRange.year:
        return _yearData();
    }
  }

  // ---------- WEEK ----------
  static AnalyticsBundle _weekData() {
    final trends = [
      TrendPoint('Mon', 20),
      TrendPoint('Tue', 25),
      TrendPoint('Wed', 18),
      TrendPoint('Thu', 30),
      TrendPoint('Fri', 22),
      TrendPoint('Sat', 15),
      TrendPoint('Sun', 20),
    ];

    final districts = [
      DistrictData('Tondo', 40),
      DistrictData('Sampaloc', 30),
      DistrictData('Ermita', 25),
      DistrictData('Malate', 20),
      DistrictData('Paco', 35),
    ];

    final illnesses = [
      IllnessData('Food Poisoning', 45, const Color(0xFF3B82F6)),
      IllnessData('E. Coli', 30, const Color(0xFFEC4899)),
      IllnessData('Norovirus', 25, const Color(0xFFF59E0B)),
      IllnessData('Salmonella', 35, const Color(0xFF8B5CF6)),
      IllnessData('Others', 15, const Color(0xFF10B981)),
    ];

    // 🔥 AUTO TOTAL (from trends)
    int total = trends.fold(0, (sum, e) => sum + e.value.toInt());

    return AnalyticsBundle(
      currentCases: total, // <-- USE TOTAL HERE
      percentChange: 34.1,
      trends: trends,
      districts: districts,
      illnesses: illnesses,
    );
  }

  // ---------- MONTH ----------
  static AnalyticsBundle _monthData() {
    // TOTAL = 320
    final trends = [
      TrendPoint('Jan', 20),
      TrendPoint('Feb', 25),
      TrendPoint('Mar', 30),
      TrendPoint('Apr', 28),
      TrendPoint('May', 35),
      TrendPoint('Jun', 40),
      TrendPoint('Jul', 38),
      TrendPoint('Aug', 32),
      TrendPoint('Sep', 27),
      TrendPoint('Oct', 22),
      TrendPoint('Nov', 13),
      TrendPoint('Dec', 10),
    ];

    // TOTAL = 320
    final districts = [
      DistrictData('Tondo', 100),
      DistrictData('Sampaloc', 70),
      DistrictData('Ermita', 50),
      DistrictData('Malate', 40),
      DistrictData('Paco', 60),
    ];

    // TOTAL = 320
    final illnesses = [
      IllnessData('Food Poisoning', 110, const Color(0xFF3B82F6)),
      IllnessData('E. Coli', 60, const Color(0xFFEC4899)),
      IllnessData('Norovirus', 50, const Color(0xFFF59E0B)),
      IllnessData('Salmonella', 70, const Color(0xFF8B5CF6)),
      IllnessData('Others', 30, const Color(0xFF10B981)),
    ];

    int total = trends.fold(0, (sum, e) => sum + e.value.toInt());

    return AnalyticsBundle(
      currentCases: total,
      percentChange: 12.5,
      trends: trends,
      districts: districts,
      illnesses: illnesses,
    );
  }

  // ---------- YEAR ----------
  static AnalyticsBundle _yearData() {
    // TOTAL = 1280
    final trends = [
      TrendPoint('2015', 80),
      TrendPoint('2016', 90),
      TrendPoint('2017', 95),
      TrendPoint('2018', 100),
      TrendPoint('2019', 110),
      TrendPoint('2020', 85),
      TrendPoint('2021', 95),
      TrendPoint('2022', 110),
      TrendPoint('2023', 120),
      TrendPoint('2024', 140),
      TrendPoint('2025', 170),
      TrendPoint('2026', 185),
    ];

    // TOTAL = 1280
    final districts = [
      DistrictData('Tondo', 350),
      DistrictData('Sampaloc', 250),
      DistrictData('Ermita', 200),
      DistrictData('Malate', 180),
      DistrictData('Paco', 300),
    ];

    // TOTAL = 1280
    final illnesses = [
      IllnessData('Food Poisoning', 420, const Color(0xFF3B82F6)),
      IllnessData('E. Coli', 250, const Color(0xFFEC4899)),
      IllnessData('Norovirus', 180, const Color(0xFFF59E0B)),
      IllnessData('Salmonella', 290, const Color(0xFF8B5CF6)),
      IllnessData('Others', 140, const Color(0xFF10B981)),
    ];
    
    int total = trends.fold(0, (sum, e) => sum + e.value.toInt());
    
    return AnalyticsBundle(
      currentCases: total,
      percentChange: 6.2,
      trends: trends,
      districts: districts,
      illnesses: illnesses,
    );
  }
}
