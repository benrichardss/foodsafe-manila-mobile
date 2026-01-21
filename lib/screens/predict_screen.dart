import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/predict_widgets.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  bool showForecast = true;

  final List<DistrictRisk> districts = const [
    DistrictRisk(
      name: 'Tondo',
      level: RiskLevel.high,
      score: 82,
      estCases: 67,
      trend: '📈 increasing',
    ),
    DistrictRisk(
      name: 'Binondo',
      level: RiskLevel.moderate,
      score: 58,
      estCases: 42,
      trend: '➡️ stable',
    ),
    DistrictRisk(
      name: 'Sta. Cruz',
      level: RiskLevel.high,
      score: 75,
      estCases: 54,
      trend: '📈 increasing',
    ),
    DistrictRisk(
      name: 'Sampaloc',
      level: RiskLevel.moderate,
      score: 45,
      estCases: 34,
      trend: '📉 decreasing',
    ),
    DistrictRisk(
      name: 'San Miguel',
      level: RiskLevel.low,
      score: 28,
      estCases: 18,
      trend: '📉 decreasing',
    ),
    DistrictRisk(
      name: 'Malate',
      level: RiskLevel.low,
      score: 22,
      estCases: 12,
      trend: '➡️ stable',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final highCount = districts.where((d) => d.level == RiskLevel.high).length;
    final avgRisk = districts.isEmpty
        ? 0
        : districts.map((d) => d.score).reduce((a, b) => a + b) /
            districts.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: const Color(0xFFF9FAFB),
        backgroundColor: Colors.white,
        toolbarHeight: 92,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Predictions & History',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Predictive analytics risk forecasting',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SegmentedToggle(
              leftLabel: 'Forecast',
              rightLabel: 'History',
              isLeftSelected: showForecast,
              onChanged: (v) => setState(() => showForecast = v),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GradientStatCard(
                      title: 'High Risk Districts',
                      value: '$highCount',
                      icon: Icons.warning_amber_rounded,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientStatCard(
                      title: 'Average Risk Score',
                      value: avgRisk.toStringAsFixed(1),
                      icon: Icons.shield_outlined,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ChartCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Case Forecast (Next Quarter)',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const Chart()
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Predicted cases with confidence intervals',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'District Risk Predictions',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              ...districts.map(
                (d) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DistrictRiskCard(district: d, onTap: () {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}