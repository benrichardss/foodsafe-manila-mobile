import 'package:flutter/material.dart';
import 'package:foodsafe_manila/screens/alerts_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  final VoidCallback onBellTap;
  const Header({super.key, required this.onBellTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 36),
      decoration: BoxDecoration(
        color:  Color(0xFF2563EB),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FoodSafe",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Stay safe, stay informed",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const AlertsScreen(),
                  ),
                ),
                borderRadius: BorderRadius.circular(999),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      right: 7,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB).withValues(alpha: .15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB).withValues(alpha: .15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Your Location",
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Tondo, Manila",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Thursday, Jan 22, 06:16 PM",
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                "Your Location",
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Tondo, Manila",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Thursday, Jan 22, 06:16 PM",
            style: GoogleFonts.inter(fontSize: 11, color: Color(0xFFDBEAFE)),
          ),
        ],
      ),
    );
  }

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Dashboard Summary",
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "2026",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _StatTile(
                    bg: Color(0xFFFFF1F2),
                    border: Color(0xFFFECACA),
                    icon: Icons.monitor_heart_outlined,
                    iconColor: Color(0xFFDC2626),
                    label: "Total Cases",
                    value: "889",
                    sub: "Jan 1–19, 2026",
                    valueColor: Color(0xFFB91C1C),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    bg: Color(0xFFFFF7ED),
                    border: Color(0xFFFED7AA),
                    icon: Icons.warning_amber_rounded,
                    iconColor: Color(0xFFD97706),
                    label: "High Risk",
                    value: "2",
                    sub: "Districts",
                    valueColor: Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _StatTile(
                    bg: Color(0xFFFAF5FF),
                    border: Color(0xFFE9D5FF),
                    icon: Icons.groups_2_outlined,
                    iconColor: Color(0xFF7C3AED),
                    label: "Most Common",
                    value: "Food Poisoning",
                    sub: "Illness Type",
                    valueColor: Color(0xFF6D28D9),
                    isSmallValue: true,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    bg: Color(0xFFEFF6FF),
                    border: Color(0xFFBFDBFE),
                    icon: Icons.map_outlined,
                    iconColor: Color(0xFF2563EB),
                    label: "Active Areas",
                    value: "23",
                    sub: "Barangays",
                    valueColor: Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final Color bg;
  final Color border;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;
  final Color valueColor;
  final bool isSmallValue;

  const _StatTile({
    required this.bg,
    required this.border,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
    required this.valueColor,
    this.isSmallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: isSmallValue ? 13 : 22,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(fontSize: 10, color: valueColor.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}

/* ---------------- Map CTA ---------------- */

class MapCtaCard extends StatelessWidget {
  const MapCtaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/map'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 8),
              color: Color(0x22000000),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconBubble(icon: Icons.navigation_rounded),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Interactive Disease Map",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Explore outbreak zones with filters & live data",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Color(0xFFCCFBF1),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.location_on_outlined, color: Colors.white),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                _DotLabel(color: Color(0xFFF87171), text: "3 High Risk Zones"),
                SizedBox(width: 14),
                _DotLabel(color: Color(0xFFFACC15), text: "5 Moderate"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  const _IconBubble({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _DotLabel extends StatelessWidget {
  final Color color;
  final String text;
  const _DotLabel({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/* ---------------- Current Risk ---------------- */

class CurrentRiskCard extends StatelessWidget {
  const CurrentRiskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Current Risk Status",
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _RiskMini(
                  icon: Icons.warning_amber_rounded,
                  bg: Color(0xFFFEE2E2),
                  fg: Color(0xFFDC2626),
                  value: "3",
                  label: "High Risk",
                ),
              ),
              Expanded(
                child: _RiskMini(
                  icon: Icons.trending_up_rounded,
                  bg: Color(0xFFFEF3C7),
                  fg: Color(0xFFD97706),
                  value: "5",
                  label: "Moderate",
                ),
              ),
              Expanded(
                child: _RiskMini(
                  icon: Icons.shield_outlined,
                  bg: Color(0xFFDCFCE7),
                  fg: Color(0xFF16A34A),
                  value: "12",
                  label: "Low Risk",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskMini extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final String value;
  final String label;

  const _RiskMini({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: fg),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: fg,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

/* ---------------- Nearby Alerts ---------------- */

class NearbyAlertsSection extends StatelessWidget {
  const NearbyAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _NearbyAlertItem(
        title: "Salmonella",
        risk: "High Risk",
        riskBg: Color(0xFFFEE2E2),
        riskFg: Color(0xFFB91C1C),
        iconBg: Color(0xFFFEE2E2),
        iconFg: Color(0xFFDC2626),
        meta: "0.5 km away",
        cases: "45 cases",
        time: "2 hours ago",
      ),
      _NearbyAlertItem(
        title: "Food Poisoning",
        risk: "Moderate Risk",
        riskBg: Color(0xFFFEF3C7),
        riskFg: Color(0xFF92400E),
        iconBg: Color(0xFFFEF3C7),
        iconFg: Color(0xFFD97706),
        meta: "1.2 km away",
        cases: "12 cases",
        time: "5 hours ago",
      ),
      _NearbyAlertItem(
        title: "E. Coli",
        risk: "Low Risk",
        riskBg: Color(0xFFDCFCE7),
        riskFg: Color(0xFF166534),
        iconBg: Color(0xFFDCFCE7),
        iconFg: Color(0xFF16A34A),
        meta: "2.8 km away",
        cases: "3 cases",
        time: "1 day ago",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Nearby Alerts",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const AlertsScreen(),
                ),
              ),
              child: Text(
                "See All",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _NearbyAlertCard(item: e),
          ),
        ),
      ],
    );
  }
}

class _NearbyAlertItem {
  final String title;
  final String risk;
  final Color riskBg;
  final Color riskFg;
  final Color iconBg;
  final Color iconFg;
  final String meta;
  final String cases;
  final String time;

  const _NearbyAlertItem({
    required this.title,
    required this.risk,
    required this.riskBg,
    required this.riskFg,
    required this.iconBg,
    required this.iconFg,
    required this.meta,
    required this.cases,
    required this.time,
  });
}

class _NearbyAlertCard extends StatelessWidget {
  final _NearbyAlertItem item;
  const _NearbyAlertCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _Card(
      radius: 14,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: item.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning_amber_rounded, color: item.iconFg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: item.riskBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.risk,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: item.riskFg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.meta,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.cases,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- Health Tips ---------------- */

class HealthTipsSection extends StatelessWidget {
  const HealthTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = const [
      _TipItem(
        title: "Food Safety",
        desc: "Always wash hands before eating and food preparation",
        icon: Icons.shield_outlined,
      ),
      _TipItem(
        title: "Prevent Contamination",
        desc: "Cook food thoroughly and store at proper temperatures",
        icon: Icons.info_outline,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Health Tips",
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        ...tips.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TipCard(item: t),
          ),
        ),
      ],
    );
  }
}

class _TipItem {
  final String title;
  final String desc;
  final IconData icon;
  const _TipItem({required this.title, required this.desc, required this.icon});
}

class _TipCard extends StatelessWidget {
  final _TipItem item;
  const _TipCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.desc,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- Emergency Hotlines ---------------- */

class EmergencyHotlinesCard extends StatelessWidget {
  const EmergencyHotlinesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      radius: 14,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Emergency Hotlines",
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          _HotlineRow(
            title: "DOH Hotline",
            subtitle: "24/7 Available",
            number: "1555",
            bg: const Color(0xFFFFF1F2),
            numberColor: const Color(0xFFDC2626),
            onTap: () => _showDialSnack(context, "1555"),
          ),
          const SizedBox(height: 10),
          _HotlineRow(
            title: "Emergency",
            subtitle: "Police, Fire, Medical",
            number: "911",
            bg: const Color(0xFFEFF6FF),
            numberColor: const Color(0xFF2563EB),
            onTap: () => _showDialSnack(context, "911"),
          ),
        ],
      ),
    );
  }

  static void _showDialSnack(BuildContext context, String num) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Dial $num")));
  }
}

class _HotlineRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;
  final Color bg;
  final Color numberColor;
  final VoidCallback onTap;

  const _HotlineRow({
    required this.title,
    required this.subtitle,
    required this.number,
    required this.bg,
    required this.numberColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: numberColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Shared Card ---------------- */

class _Card extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;

  const _Card({
    required this.child,
    this.radius = 18,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: child,
    );
  }
}