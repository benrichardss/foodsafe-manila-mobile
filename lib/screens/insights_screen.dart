import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../data/mock_analytics_data.dart';
import '../widgets/analytics_widgets.dart' as analytics_widgets;
import '../widgets/predict_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool showStatistics = true;
  bool showOfficial = true;
  String selectedTime = "Last 7 Days";

  String? selectedDistrict;

  Color get statisticsThemeColor =>
      showOfficial ? const Color(0xFF059669) : const Color(0xFFEA580C);

  Color get statisticsThemeSurfaceColor =>
      showOfficial ? const Color(0xFFDCFCE7) : const Color(0xFFFFEDD5);

  final data = MockAnalyticsData.getData(analytics_widgets.TimeRange.week);

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: segmentedToggle(
              color: Color(0xFF2563EB),
              leftLabel: 'Statistics',
              rightLabel: 'Forecast',
              isLeftSelected: showStatistics,
              onChanged: (v) => setState(() => showStatistics = v),
            ),
          ),
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
    final themeColor = statisticsThemeColor;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.layers,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Filters",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Data Source',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            segmentedToggle(
              color: themeColor,
              leftIcon: LucideIcons.fileText,
              rightIcon: LucideIcons.shield,
              leftLabel: 'Official',
              rightLabel: 'Reports',
              isLeftSelected: showOfficial,
              onChanged: (v) => setState(() => showOfficial = v),
            ),

            const SizedBox(height: 16),

            Text(
              'Time Period',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  timeButton("Last 7 Days"),
                  timeButton("This Month"),
                  timeButton("This Year"),
                  timeButton("3 Years"),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        chartCard(
          accentColor: themeColor,
          headingIcon: LucideIcons.mapPin,
          heading: 'Cases by District',
          subheading: 'Geographic distribution',
          chart: barChart(themeColor),
          footerIcon: Icons.my_location,
          footerHeading: 'Hotspot Analysis',
          footerContent:
              "Tondo has the highest cases (245). Total across all districts: 889.",
        ),
        SizedBox(height: 16),
        chartCard(
          accentColor: themeColor,
          headingIcon: LucideIcons.activity,
          heading: 'Case Trends',
          subheading: 'Temporal patterns',
          enableDropdown: true,
          chart: lineChart(
            labels: [
              "Week 1 Days 1-7",
              "Week 2 Days 8-14",
              "Week 3 Days 15-21",
              "Week 4 Days 22-28",
            ],
            minY: 0,
            maxY: 280,
            data: const [
              FlSpot(0, 142),
              FlSpot(1, 165),
              FlSpot(2, 158),
              FlSpot(3, 178),
            ],
            accentColor: themeColor,
          ),
          footerIcon: LucideIcons.trendingUp,
          footerHeading: 'Trend Analysis',
          footerContent:
              "Cases are increasing by 12.7% compared to the previous period. Current: 178 cases.",
        ),
        SizedBox(height: 16),
        chartCard(
          accentColor: themeColor,
          headingIcon: LucideIcons.layers,
          heading: 'Symptoms Distribution',
          subheading: 'Category breakdown',
          enableDropdown: true,
          chart: pieChart(),
          footerIcon: LucideIcons.users,
          footerHeading: 'Top symptom',
          footerContent:
              "Diarrhea is the most reported symptom (23.6%). Total symptom reports: 1321.",
        ),
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

            dropdownButton(),
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

        _forecastChart(
          labels: [
            "Week 1 Days 1-7",
            "Week 2 Days 8-14",
            "Week 3 Days 15-21",
            "Week 4 Days 22-28",
          ],
          minY: 50,
          maxY: 70,
          upperBoundData: const [
            FlSpot(0, 60),
            FlSpot(1, 55),
            FlSpot(2, 58),
            FlSpot(3, 62),
          ],
          lowerBoundData: const [
            FlSpot(0, 65),
            FlSpot(1, 60),
            FlSpot(2, 63),
            FlSpot(3, 66),
          ],
        ),

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

  Widget timeButton(String text) {
    final bool isActive = selectedTime == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = text;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? statisticsThemeColor : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: isActive ? null : Border.all(color: const Color(0xFFD1D5DB)),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  Widget dropdownButton() {
    return Theme(
      data: Theme.of(context).copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: DropdownMenu<String>(
        initialSelection: 'All Districts',
        onSelected: (value) {
          setState(() {
            selectedDistrict = value;
          });
        },

        width: double.infinity,

        hintText: 'Choose district...',

        leadingIcon: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(LucideIcons.mapPin, size: 20),
        ),

        trailingIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),

        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),

        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
        ),

        dropdownMenuEntries:
            [
              'All Districts',
              'Tondo',
              'Binondo',
              'Sampaloc',
              'Santa Cruz',
              'San Miguel',
              'Quiapo',
            ].map((district) {
              return DropdownMenuEntry(
                value: district,
                label: district,
                labelWidget: Text(
                  district,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget chartCard({
    required Color accentColor,
    required IconData headingIcon,
    required String heading,
    required String subheading,
    bool enableDropdown = false,
    required Widget chart,
    required IconData footerIcon,
    required String footerHeading,
    required String footerContent,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(headingIcon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    subheading,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          enableDropdown
              ? Column(
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

                    dropdownButton(),

                    const SizedBox(height: 20),
                  ],
                )
              : SizedBox.shrink(),

          /// CHART
          chart,

          const SizedBox(height: 20),

          /// FOOTER INSIGHT
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.35)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(footerIcon, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        footerHeading,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        footerContent,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget barChart(Color accentColor) {
    final districts = [
      "Tondo",
      "Binondo",
      "Sta. Cruz",
      "Sampaloc",
      "San Miguel",
      "Malate",
    ];

    final values = [245.0, 180.0, 130.0, 110.0, 80.0, 55.0];

    return Container(
      height: 240,
      padding: EdgeInsets.fromLTRB(12, 0, 18, 0),
      child: BarChart(
        BarChartData(
          maxY: 260,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 65,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.15),
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
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            /// Y AXIS
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 65,
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
                  if (index >= districts.length) return const SizedBox();

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
                  color: accentColor,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget lineChart({
    required List<FlSpot> data,
    required List<String> labels,
    double minY = 0,
    double maxY = 100,
    required Color accentColor,
  }) {
    LineChartBarData line(List<FlSpot> data, Color color) {
      return LineChartBarData(
        spots: data,
        isCurved: true,
        curveSmoothness: 0.35,
        color: color.withOpacity(0.9),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
      );
    }

    return Container(
      height: 240,
      padding: EdgeInsets.fromLTRB(12, 0, 18, 0),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,

          /// GRID
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.15),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),

          /// BORDER
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey.shade400),
              bottom: BorderSide(color: Colors.grey.shade400),
            ),
          ),

          /// TITLES
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            /// X AXIS
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 44,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();

                  if (index >= 0 && index < labels.length) {
                    final label = labels[index]; // "Week 1 (1-7)"

                    // Split into: "Week 1" and "(1-7)"
                    final main = label.substring(0, label.indexOf('D')).trim();
                    final sub = label.substring(label.indexOf('D'));

                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$main\n",
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            TextSpan(
                              text: sub,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),

            /// Y AXIS
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: (maxY - minY) / 4,
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
          ),

          /// TOUCH
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(8),
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    spot.y.toStringAsFixed(1),
                    GoogleFonts.inter(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),

          /// DATA
          lineBarsData: [line(data, accentColor)],
        ),
      ),
    );
  }

  Widget pieChart() {
    final symptoms = [
      {
        'label': 'Vomiting',
        'value': 245,
        'percent': 19,
        'color': const Color(0xFFEF4444),
      },
      {
        'label': 'Diarrhea',
        'value': 312,
        'percent': 24,
        'color': const Color(0xFFF97316),
      },
      {
        'label': 'Nausea',
        'value': 198,
        'percent': 15,
        'color': const Color(0xFFF59E0B),
      },
      {
        'label': 'Fever',
        'value': 156,
        'percent': 12,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'label': 'Stomach Pain',
        'value': 189,
        'percent': 14,
        'color': const Color(0xFF3B82F6),
      },
      {
        'label': 'Headache',
        'value': 123,
        'percent': 9,
        'color': const Color(0xFF06B6D4),
      },
      {
        'label': 'Weakness',
        'value': 98,
        'percent': 7,
        'color': const Color(0xFF10B981),
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: symptoms.map((item) {
                return PieChartSectionData(
                  value: (item['value'] as int).toDouble(),
                  color: item['color'] as Color,
                  title: '${item['percent']}%',
                  radius: 95,
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  titlePositionPercentageOffset: 0.7,
                );
              }).toList(),
            ),
          ),
        ),

        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: symptoms.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: item['color'] as Color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${item['label']} ',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '(${item['value']})',
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
          }).toList(),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget _forecastChart({
    required List<FlSpot> upperBoundData,
    required List<FlSpot> lowerBoundData,
    required List<String> labels,
    double minY = 0,
    double maxY = 100,
  }) {
    LineChartBarData line(List<FlSpot> data, Color color) {
      return LineChartBarData(
        spots: data,
        isCurved: true,
        curveSmoothness: 0.35,
        color: color.withOpacity(0.9),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
      );
    }

    Widget legendItem(Color color, String label) {
      return Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 10, color: color)),
        ],
      );
    }

    return Container(
      height: 300,
      padding: EdgeInsets.fromLTRB(24, 36, 36, 24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Chart
          Expanded(
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,

                /// GRID
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),

                /// BORDER
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade400),
                    bottom: BorderSide(color: Colors.grey.shade400),
                  ),
                ),

                /// TITLES
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  /// X AXIS
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 44,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();

                        if (index >= 0 && index < labels.length) {
                          final label = labels[index]; // "Week 1 (1-7)"

                          // Split into: "Week 1" and "(1-7)"
                          final main = label
                              .substring(0, label.indexOf('D'))
                              .trim();
                          final sub = label.substring(label.indexOf('D'));

                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "$main\n",
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: sub,
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),

                  /// Y AXIS
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: (maxY - minY) / 4,
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
                ),

                /// TOUCH
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          spot.y.toStringAsFixed(1),
                          GoogleFonts.inter(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),

                /// DATA
                lineBarsData: [
                  line(upperBoundData, Colors.green),
                  line(lowerBoundData, Colors.orange),
                ],
              ),
            ),
          ),

          /// 🔹 Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              legendItem(Colors.green, "Upper bound"),
              const SizedBox(width: 16),
              legendItem(Colors.orange, "Lower bound"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required Color bgColor,
    required Color textColor,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white70),
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
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "cases/week",
            style: GoogleFonts.inter(color: textColor, fontSize: 11),
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
