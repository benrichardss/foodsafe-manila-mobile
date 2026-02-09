import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
      body: SafeArea(
        top: true,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 36),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF1D4ED8),
                  ], // from-blue-600 to-blue-700
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        SizedBox(width: 6),
                        Text(
                          "Back",
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Emergency Contacts',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Important health and emergency numbers',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2), // red-50
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFECACA), width: 2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.phone_in_talk_outlined,
                              color: Color(0xFFDC2626), size: 26),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "In Case of Emergency",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF7F1D1D),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "For life-threatening emergencies, call 911 immediately",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFFB91C1C),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ), 
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "National Hotlines",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// HOTLINE ITEM WIDGET
                          _hotlineItem(
                            title: "DOH Health Emergency Hotline",
                            subtitle: "24/7 health emergency assistance",
                            number: "1555",
                            isHotline: true
                          ),

                          const Divider(height: 32),

                          _hotlineItem(
                            title: "DOH COVID-19 Hotline",
                            subtitle: "COVID-19 related inquiries",
                            number: "+63 2 8651 7800",
                            isHotline: true
                          ),

                          const Divider(height: 32),

                          _hotlineItem(
                            title: "Red Cross Emergency Hotline",
                            subtitle: "Emergency medical services",
                            number: "143",
                            isHotline: true
                          ),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Manila City Health Office",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// HOTLINE ITEM WIDGET
                          _hotlineItem(
                            title: "Manila Health Department",
                            subtitle: "General health inquiries",
                            number: "+63 2 8711 6074",
                            isHotline: true,
                            email: 'healthoffice@manila.gov.ph'
                          ),

                          const Divider(height: 32),

                          _hotlineItem(
                            title: "Manila Disease Surveillance",
                            subtitle: "Report disease outbreaks",
                            number: "+63 2 8310 8560",
                            isHotline: true,
                            email: 'surveillance@manila.gov.ph'
                          ),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Emergency Services",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// HOTLINE ITEM WIDGET
                          _hotlineItem(
                            title: "Emergency Medical Services",
                            subtitle: "Police, Fire, and Medical Emergencies",
                            number: "911",
                            isHotline: true
                          ),

                          const Divider(height: 32),

                          _hotlineItem(
                            title: "Metro Manila Emergency Hotline",
                            subtitle: "Metropolitan-wide emergencies",
                            number: "+136",
                            isHotline: true
                          ),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hospitals & Treatment Centers",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// HOTLINE ITEM WIDGET
                          _hotlineItem(
                            title: "San Lazaro Hospital",
                            subtitle: "Infectious disease hospital",
                            number: "+63 2 8711 4251",
                            isHotline: false,
                            location: 'Quiricada St, Santa Cruz, Manila'
                          ),

                          const Divider(height: 32),

                          _hotlineItem(
                            title: "Philippine General Hospital",
                            subtitle: "Report disease outbreaks",
                            number: "+63 2 8310 8560",
                            isHotline: false,
                            location: "Taft Ave, Ermita, Manila"
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _hotlineItem({
    required String title,
    required String subtitle,
    required String number,
    required bool isHotline,
    String? email,
    String? location
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF), // blue-50
                shape: BoxShape.circle,
              ),
              child: Icon(isHotline? Icons.phone_outlined: Icons.location_on_outlined,
                  size: 18, color: Color(0xFF2563EB)),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.call_outlined,
                          size: 16, color: Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      Text(
                        number,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  isHotline
                      ? email != null
                          ? Row(
                            children: [
                              const Icon(Icons.email_outlined,
                                  size: 16, color: Color(0xFF2563EB)),
                              const SizedBox(width: 6),
                              Text(
                                email,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF2563EB),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                          : const SizedBox.shrink()
                      : location != null
                          ? Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                location,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          )
                          : const SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}