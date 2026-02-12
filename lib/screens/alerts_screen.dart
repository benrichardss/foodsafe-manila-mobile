import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/alerts_widgets.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int unreadCount = 2;
  RiskLevel? selectedFilter;
  bool showFilterChips = false;


  final List<AlertItem> alerts = const [
    AlertItem(
      title: "Salmonella",
      risk: RiskLevel.high,
      message:
          "Increased cases reported in the area. Avoid raw or undercooked food.",
      location: "Tondo",
      timeAgo: "2 hours ago",
      cases: "45 cases reported",
      distance: "0.5 km away",
    ),
    AlertItem(
      title: "Food Poisoning",
      risk: RiskLevel.moderate,
      message:
          "Food contamination suspected at local market. Practice food safety.",
      location: "Binondo",
      timeAgo: "5 hours ago",
      cases: "12 cases reported",
      distance: "1.2 km away",
    ),
    AlertItem(
      title: "E. Coli",
      risk: RiskLevel.low,
      message:
          "Monitor symptoms. Ensure clean drinking water and proper food handling.",
      location: "Sampaloc",
      timeAgo: "1 day ago",
      cases: "3 cases reported",
      distance: "2.8 km away",
    ),
    AlertItem(
      title: "Campylobacter",
      risk: RiskLevel.high,
      message: "Linked to poultry products. Cook chicken thoroughly.",
      location: "Sta. Cruz",
      timeAgo: "1 day ago",
      cases: "23 cases reported",
      distance: "3.2 km away",
    ),
    AlertItem(
      title: "Norovirus",
      risk: RiskLevel.moderate,
      message:
          "Highly contagious. Wash hands frequently and avoid sharing utensils.",
      location: "Quiapo",
      timeAgo: "2 days ago",
      cases: "8 cases reported",
      distance: "1.8 km away",
    ),
    AlertItem(
      title: "Listeria",
      risk: RiskLevel.moderate,
      message: "Linked to dairy products. Check refrigerator temperatures.",
      location: "Ermita",
      timeAgo: "3 days ago",
      cases: "15 cases reported",
      distance: "2.1 km away",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = selectedFilter == null
        ? alerts
        : alerts.where((a) => a.risk == selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        surfaceTintColor: const Color(0xFFF9FAFB),
        backgroundColor: Colors.white,
        toolbarHeight: 92, // stays constant
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Alerts & Notifications',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$unreadCount unread notifications',
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
              onTap: () {
                setState(() {
                  showFilterChips = !showFilterChips;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.filter_list_rounded,
                  size: 20,
                  color: Color(0xFF4B5563),
                ),
              ),
            ),
          ),
        ],
        bottom: showFilterChips
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChip("All", null),
                          const SizedBox(width: 8),
                          _buildChip("High Risk", RiskLevel.high),
                          const SizedBox(width: 8),
                          _buildChip("Moderate Risk", RiskLevel.moderate),
                          const SizedBox(width: 8),
                          _buildChip("Low Risk", RiskLevel.low),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                children: filteredAlerts.map((item) {
                  final index = alerts.indexOf(item);
                  final isUnread = index < unreadCount;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AlertCard(
                      item: item,
                      isUnread: isUnread,
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        elevation: 6,
                      ),
                      onPressed: unreadCount == 0
                          ? null
                          : () => setState(() => unreadCount = 0),
                      child: Text(
                        unreadCount == 0
                            ? "All Read"
                            : "Mark All as Read ($unreadCount)",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  ChoiceChip _buildChip(String label, RiskLevel? risk) {
    final isSelected = selectedFilter == risk;
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFFF3F4F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      onSelected: (_) {
        setState(() {
          selectedFilter = risk;
        });
      },
    );
  }
}
