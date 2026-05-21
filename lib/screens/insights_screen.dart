import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/api_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool showStatistics = true;
  bool showOfficial = true;

  /// Prediction chart filters
  String predictionDistrict = 'all';
  String predictionRange = '3';

  /// Case Trends filters
  String trendsYear = DateTime.now().year.toString();
  String trendsClassification = 'all';

  /// District chart filters
  String districtMonth = DateTime.now().month.toString();
  String districtYear = DateTime.now().year.toString();
  String districtClassification = 'all';

  /// Disease chart filters
  String diseaseMonth = DateTime.now().month.toString();
  String diseaseYear = DateTime.now().year.toString();
  String diseaseClassification = 'all';

  final List<String> districtItems = [
    'all',
    'district 1',
    'district 2',
    'district 3',
    'district 4',
    'district 5',
    'district 6',
  ];

  final List<String> rangeItems = [
    '3',
    '6',
    '12'
  ];

  final List<String> monthItems = [
    'all',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
  final List<String> yearItems = ['all', '2023', '2024', '2025', '2026'];
  final List<String> caseClassificationItems = [
    'all',
    'confirmed',
    'suspected',
    'probable',
  ];

  Map<String, dynamic>? overviewData;
  Map<String, dynamic>? trendsData;
  Map<String, dynamic>? districtData;
  Map<String, dynamic>? diseaseData;

  bool isOverviewLoading = true;
  bool isPredictLoading = true;
  bool isTrendsLoading = true;
  bool isDistrictLoading = true;
  bool isDiseaseLoading = true;

  double getNiceInterval(double max) {
    if (max <= 10) return 2;
    if (max <= 25) return 5;
    if (max <= 50) return 10;
    if (max <= 75) return 15;
    if (max <= 100) return 20;
    if (max <= 250) return 50;
    if (max <= 500) return 100;
    if (max <= 750) return 150;
    if (max <= 1000) return 200;
    return (max / 5).ceilToDouble();
  }

  double getNiceMaxY(double maxValue) {
    final interval = getNiceInterval(maxValue);
    return (maxValue / interval).ceil() * interval;
  }

  @override
  void initState() {
    super.initState();
    loadAllAnalytics();
  }

  Future<void> loadAllAnalytics() async {
    await Future.wait([
      fetchOverview(),
      fetchTrends(),
      fetchDistrict(),
      fetchDisease(),
    ]);
  }

  Future<void> fetchOverview() async {
    setState(() => isOverviewLoading = true);

    final result = await ApiService.getOfficialAnalytics();

    setState(() {
      overviewData = result;
      isOverviewLoading = false;
    });
  }

  Future<void> fetchTrends() async {
    setState(() => isTrendsLoading = true);

    final result = await ApiService.getOfficialAnalytics(
      year: trendsYear,
      caseClassification: trendsClassification,
    );

    setState(() {
      trendsData = result;
      isTrendsLoading = false;
    });
  }

  Future<void> fetchDistrict() async {
    setState(() => isDistrictLoading = true);

    final result = await ApiService.getOfficialAnalytics(
      month: districtMonth,
      year: districtYear,
      caseClassification: districtClassification,
    );

    setState(() {
      districtData = result;
      isDistrictLoading = false;
    });
  }

  Future<void> fetchDisease() async {
    setState(() => isDiseaseLoading = true);

    final result = await ApiService.getOfficialAnalytics(
      month: diseaseMonth,
      year: diseaseYear,
      caseClassification: diseaseClassification,
    );

    setState(() {
      diseaseData = result;
      isDiseaseLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
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
              'Analytics',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Statistics & Forecast',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: showStatistics ? statisticsView() : forecastView(),
          ),
        ),
      ),
    );
  }

  Widget statisticsView() {
    final growth = overviewData?['growth'];

    final growthValue = double.tryParse(growth.toString()) ?? 0.0;

    final growthText =
        "${growthValue >= 0 ? '+' : ''}${growthValue.toStringAsFixed(1)}%";

    Color growthColor = growthValue >= 0
        ? const Color(0xFF059669) // green
        : const Color(0xFFDC2626); // red

    return Column(
      children: [
        /// KPI CARDS
        Row(
          children: [
            Expanded(
              child: _statCard(
                bgColor: Colors.white,
                textColor: Colors.black,
                icon: LucideIcons.activity,
                title: "Total Cases",
                value: overviewData?['totalCases']?.toString() ?? '0',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                bgColor: Colors.white,
                textColor: Colors.black,
                icon: LucideIcons.mapPin,
                title: "Top District",
                subtitle: 'Highest case volume',
                value: overviewData?['topDistrict'] ?? 'N/A',
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _statCard(
                bgColor: Colors.white,
                textColor: Colors.black,
                icon: LucideIcons.triangleAlert,
                title: "Growth",
                subtitle: 'vs last year',
                value: growthText,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                bgColor: Colors.white,
                textColor: Colors.black,
                icon: LucideIcons.stethoscope,
                title: "Top Disease",
                subtitle: 'Most frequent diagnosis',
                value: overviewData?['topDisease'] ?? 'N/A',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        predictionChart(),

        const SizedBox(height: 16),

        caseTrendsChart(),

        const SizedBox(height: 16),

        casesByDistrictChart(),

        const SizedBox(height: 16),

        diseaseDistributionChart(),
      ],
    );
  }

  Widget forecastView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.sparkles,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monthly Forecast",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "May 1-31, 2026",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),

        const SizedBox(height: 20),

        /// STATS
        Row(
          children: [
            Expanded(
              child: _statCard(
                bgColor: Color(0xFF059669),
                textColor: Color(0xFFD1FAE5),
                icon: LucideIcons.shield,
                title: "Avg Official",
                value: "44",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                bgColor: Color(0xFFEA580C),
                textColor: Color(0xFFFFEDD5),
                icon: LucideIcons.fileText,
                title: "Avg Reports",
                value: "76",
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const SizedBox(height: 20),

        /// AI INSIGHT
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Official cases show decreasing trend, while citizen reports also show a decreasing pattern. Shaded areas represent 95% confidence intervals.",
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// ABOUT FORECAST
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lightbulb,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "About Forecasting",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _infoBox(
                "The forecast shows predicted cases for the next month with confidence intervals.",
              ),

              const SizedBox(height: 8),

              _infoBox(
                "Official cases are verified, while citizen reports help detect outbreaks faster.",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget segmentedToggle({
    required Color color,
    IconData? leftIcon,
    IconData? rightIcon,
    required String leftLabel,
    required String rightLabel,
    required bool isLeftSelected,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: segButton(
              color: color,
              icon: leftIcon,
              label: leftLabel,
              selected: isLeftSelected,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: segButton(
              color: color,
              icon: rightIcon,
              label: rightLabel,
              selected: !isLeftSelected,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget segButton({
    required Color color,
    required String label,
    IconData? icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chartLoading() {
    return SizedBox(
      height: 180,
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget emptyChartWrapper({
    required Widget chart,
    required bool isEmpty,
    String message = 'No data for selected filters',
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(height: 180, child: chart),

        if (isEmpty)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.databaseZap,
                size: 20,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget noDataCard({String? chartType}) {
    IconData? icon;

    switch (chartType) {
      case 'line':
        icon = LucideIcons.chartSpline;
      case 'bar':
        icon = LucideIcons.chartColumnBig;
      case 'pie':
        icon = LucideIcons.chartPie;
      default:
        icon = Icons.insert_chart_outlined;
    }

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'No data available',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget predictionChart() {
    double minY = 0;

    final trend = trendsData?['trendData'] as List<dynamic>? ?? [];

    final bool isAllYears = trendsYear == 'all';
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    List<double> values = [];
    List<String> labels = [];

    if (isAllYears) {
      for (final item in trend) {
        values.add((item['total'] as num).toDouble());
        labels.add(item['_id'].toString()); // year label
      }
    } else {
      int maxMonth = 12;

      if (int.parse(trendsYear) == currentYear) {
        maxMonth = currentMonth; // only available months
      }

      values = List<double>.filled(maxMonth, 0);

      for (final item in trend) {
        final month = item['_id'] as int;
        final total = (item['total'] as num).toDouble();

        if (month <= maxMonth) {
          values[month - 1] = total;
        }
      }

      labels = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ].sublist(0, maxMonth);
    }

    List<FlSpot> getTrendSpots() {
      return List.generate(
        values.length,
        (index) => FlSpot(index.toDouble(), values[index]),
      );
    }

    double getTrendMaxY() {
      if (trend.isEmpty) return 100;

      final max = values.isEmpty ? 100 : values.reduce((a, b) => a > b ? a : b);

      return getNiceMaxY(max.toDouble());
    }

    final maxY = getTrendMaxY();
    final interval = getNiceInterval(maxY);

    LineChartBarData line(List<FlSpot> data) {
      return LineChartBarData(
        spots: data,
        isCurved: true,
        curveSmoothness: 0.35,
        color: Colors.blue.withValues(alpha: 0.9),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.trendingUpDown,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Predictions',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'District',
                  value: predictionDistrict,
                  items: districtItems,
                  onChanged: (value) {
                    setState(() => predictionDistrict = value!);
                    fetchTrends();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'Time Range',
                  value: predictionRange,
                  items: rangeItems,
                  onChanged: (value) {
                    setState(() => predictionRange = value!);
                    fetchTrends();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Chart
          isTrendsLoading
              ? chartLoading()
              : Container(
                  height: 180,
                  padding: const EdgeInsets.only(right: 26),
                  child: LineChart(
                    LineChartData(
                      minY: minY,
                      maxY: values.every((e) => e == 0) ? 10 : maxY,

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withValues(alpha: 0.15),
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),

                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey.shade400),
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),

                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 32,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();

                              if (index >= 0 && index < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    labels[index],
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 26,
                            interval: interval,
                            getTitlesWidget: (value, _) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  value.toInt().toString(),
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      lineBarsData: [
                        line(getTrendSpots()),
                        line(getTrendSpots()),
                      ],
                    ),
                  ),
                ),
          if (!isTrendsLoading) ...[
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(width: 6),
                    Text(
                      'Actual',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(width: 6),
                    Text(
                      'Prediction',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget caseTrendsChart() {
    double minY = 0;

    final trend = trendsData?['trendData'] as List<dynamic>? ?? [];

    final bool isAllYears = trendsYear == 'all';
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    List<double> values = [];
    List<String> labels = [];

    if (isAllYears) {
      for (final item in trend) {
        values.add((item['total'] as num).toDouble());
        labels.add(item['_id'].toString()); // year label
      }
    } else {
      int maxMonth = 12;

      if (int.parse(trendsYear) == currentYear) {
        maxMonth = currentMonth; // only available months
      }

      values = List<double>.filled(maxMonth, 0);

      for (final item in trend) {
        final month = item['_id'] as int;
        final total = (item['total'] as num).toDouble();

        if (month <= maxMonth) {
          values[month - 1] = total;
        }
      }

      labels = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ].sublist(0, maxMonth);
    }

    List<FlSpot> getTrendSpots() {
      return List.generate(
        values.length,
        (index) => FlSpot(index.toDouble(), values[index]),
      );
    }

    double getTrendMaxY() {
      if (trend.isEmpty) return 100;

      final max = values.isEmpty ? 100 : values.reduce((a, b) => a > b ? a : b);

      return getNiceMaxY(max.toDouble());
    }

    final maxY = getTrendMaxY();
    final interval = getNiceInterval(maxY);

    LineChartBarData line(List<FlSpot> data) {
      return LineChartBarData(
        spots: data,
        isCurved: true,
        curveSmoothness: 0.35,
        color: Colors.blue.withValues(alpha: 0.9),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.activity,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Case Trends',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Year',
                  value: trendsYear,
                  items: yearItems,
                  onChanged: (value) {
                    setState(() => trendsYear = value!);
                    fetchTrends();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'Classification',
                  value: trendsClassification,
                  items: caseClassificationItems,
                  onChanged: (value) {
                    setState(() => trendsClassification = value!);
                    fetchTrends();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Chart
          isTrendsLoading
              ? chartLoading()
              : Container(
                  height: 180,
                  padding: const EdgeInsets.only(right: 26),
                  child: LineChart(
                    LineChartData(
                      minY: minY,
                      maxY: values.every((e) => e == 0) ? 10 : maxY,

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withValues(alpha: 0.15),
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),

                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey.shade400),
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),

                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 32,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();

                              if (index >= 0 && index < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    labels[index],
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 26,
                            interval: interval,
                            getTitlesWidget: (value, _) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  value.toInt().toString(),
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      lineBarsData: [line(getTrendSpots())],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget casesByDistrictChart() {
    final district = districtData?['districtData'] as List<dynamic>? ?? [];

    final districts = [
      'District 1',
      'District 2',
      'District 3',
      'District 4',
      'District 5',
      'District 6',
    ];

    final Map<String, double> districtMap = {
      for (var item in district)
        item['_id'].toString(): (item['total'] as num).toDouble(),
    };

    final values = districts
        .map((districtName) => districtMap[districtName] ?? 0.0)
        .toList();

    final maxValue = values.isEmpty
        ? 100
        : values.reduce((a, b) => a > b ? a : b);

    final maxY = getNiceMaxY(maxValue.toDouble());

    final interval = getNiceInterval(maxValue.toDouble());

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.mapPin,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cases by District',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Month',
                  value: districtMonth,
                  items: monthItems,
                  onChanged: (value) {
                    setState(() => districtMonth = value!);
                    fetchDistrict();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'Year',
                  value: districtYear,
                  items: yearItems,
                  onChanged: (value) {
                    setState(() => districtYear = value!);
                    fetchDistrict();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'Classification',
                  value: districtClassification,
                  items: caseClassificationItems,
                  onChanged: (value) {
                    setState(() => districtClassification = value!);
                    fetchDistrict();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Chart
          isDistrictLoading
              ? chartLoading()
              : Container(
                  height: 180,
                  padding: const EdgeInsets.only(right: 26),
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: interval,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withValues(alpha: 0.15),
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey.shade400),
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        /// Y AXIS
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 26,
                            interval: interval,
                            getTitlesWidget: (value, _) {
                              return Padding(
                                padding: EdgeInsetsGeometry.only(right: 6),
                                child: Text(
                                  value.toInt().toString(),
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        /// X AXIS
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 44,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= districts.length) {
                                return const SizedBox();
                              }

                              return Transform.rotate(
                                angle: -0.6,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    districts[index],
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      barGroups: List.generate(districts.length, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: values[index],
                              width: 32,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              color: Colors.blue,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget diseaseDistributionChart() {
    final rawDiseases =
        diseaseData?['diseaseDistribution'] as List<dynamic>? ?? [];

    final totalCases = rawDiseases.fold<double>(
      0,
      (sum, item) => sum + (item['total'] as num).toDouble(),
    );

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.purple,
      Colors.blue,
      Colors.cyan,
      Colors.green,
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.layers,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Disease Distribution',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Month',
                  value: diseaseMonth,
                  items: monthItems,
                  onChanged: (value) {
                    setState(() => diseaseMonth = value!);
                    fetchDisease();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'Year',
                  value: diseaseYear,
                  items: yearItems,
                  onChanged: (value) {
                    setState(() => diseaseYear = value!);
                    fetchDisease();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'Classification',
                  value: diseaseClassification,
                  items: caseClassificationItems,
                  onChanged: (value) {
                    setState(() => diseaseClassification = value!);
                    fetchDisease();
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          /// Chart
          isDiseaseLoading
              ? chartLoading()
              : SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: rawDiseases.isEmpty
                          ? [
                              PieChartSectionData(
                                value: 1,
                                color: Colors.grey.shade200,
                                title: '',
                                radius: 80,
                              ),
                            ]
                          : List.generate(rawDiseases.length, (index) {
                              final item = rawDiseases[index];
                              final value = (item['total'] as num).toDouble();

                              final percent = totalCases == 0
                                  ? 0
                                  : ((value / totalCases) * 100).round();

                              return PieChartSectionData(
                                value: value,
                                color: colors[index % colors.length],
                                title: '$percent%',
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }),
                    ),
                  ),
                ),

          if (!isDiseaseLoading && rawDiseases.isNotEmpty) ...[
            SizedBox(height: 24),
            Wrap(
              spacing: 14,
              runSpacing: 8,
              children: List.generate(rawDiseases.length, (index) {
                final item = rawDiseases[index];

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${item['_id']} ',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '(${item['total']})',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  String formatDropdownText(String item, String label) {
    const months = {
      '1': 'Jan',
      '2': 'Feb',
      '3': 'Mar',
      '4': 'Apr',
      '5': 'May',
      '6': 'Jun',
      '7': 'Jul',
      '8': 'Aug',
      '9': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
    };

    if (item == 'all') {
      if (label == 'Month') return 'All';
      if (label == 'Classification') return 'All';
      if (label == 'Year') return 'All';
      return 'All';
    }
    
    if (label == 'Time Range') {
      return '$item months';
    }

    if (months.containsKey(item)) {
      return months[item]!;
    }

    return item[0].toUpperCase() + item.substring(1).toLowerCase();
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            isDense: true,
            isExpanded: true,
            value: value,
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.keyboard_arrow_down, size: 16),
            style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(formatDropdownText(item, label)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required Color bgColor,
    required Color textColor,
    required IconData icon,
    required String title,
    String? subtitle,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 12, color: textColor),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.inter(color: textColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle ?? '',
            style: GoogleFonts.inter(color: textColor, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget statOverviewCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = const Color(0xFF111827),
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: GoogleFonts.inter(fontSize: 12)),
    );
  }
}
