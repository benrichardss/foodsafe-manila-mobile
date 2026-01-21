import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/analytics_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  TimeRange range = TimeRange.month;
  ViewTab tab = ViewTab.trends;

  @override
  Widget build(BuildContext context) {
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
              'Analytics & Trends',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Disease patterns and insights',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.download,
                  size: 20,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TimeRangeChips(
              value: range,
              onChanged: (v) => setState(() => range = v),
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
              CurrentCasesCard(
                cases: 110,
                changePercent: 34.1,
                subtitle: 'Increase from previous day',
                onTap: () {},
              ),
              const SizedBox(height: 14),
              SegmentedTabs(
                value: tab,
                onChanged: (v) => setState(() => tab = v),
              ),
              const SizedBox(height: 14),
              ChartCard(
                title: tab == ViewTab.trends
                    ? 'Case Trends'
                    : tab == ViewTab.districts
                        ? 'Cases by District'
                        : 'Cases by Illness',
                child: Chart(tab: tab),
              ),
              const SizedBox(height: 14),
              SectionTitle(text: 'Key Insights'),
              const SizedBox(height: 10),
              InsightCard(
                colorBg: const Color(0xFFEFF6FF),
                colorBorder: const Color(0xFFDBEAFE),
                iconBg: const Color(0xFF2563EB),
                icon: Icons.trending_up,
                title: 'Highest Cases',
                description:
                    'Tondo district has the highest cases (245) this month',
              ),
              const SizedBox(height: 10),
              InsightCard(
                colorBg: const Color(0xFFF5F3FF),
                colorBorder: const Color(0xFFE9D5FF),
                iconBg: const Color(0xFF7C3AED),
                icon: Icons.calendar_month,
                title: 'Most Common',
                description: 'Food Poisoning accounts for 35% of all cases',
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Expanded(
                    child: StatCard(
                      label: 'Total Cases',
                      value: '889',
                      footnote: 'Last 30 days',
                      footnoteColor: Color(0xFF16A34A),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Avg Per Day',
                      value: '29.6',
                      footnote: 'cases/day',
                      footnoteColor: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}