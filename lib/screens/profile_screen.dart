import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched1 = true;
  bool isSwitched2 = true;
  bool isSwitched3 = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFFF9FAFB),
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setSp(150),
              width: ScreenUtil().screenWidth,
              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
              color: Color(0xFF1555F3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(5)),
                  Text(
                    'Manage your account preferences',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, ScreenUtil().setSp(-30)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsetsGeometry.all(15),
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color(0xFF1555F3),
                                  child: Text(
                                    'J',
                                    style: GoogleFonts.inter(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setSp(10)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Juan Dela Cruz',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: ScreenUtil().setSp(5)),
                                    Text(
                                      'juandelacruz@email.com',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      '+63 912 345 6789',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setSp(15)),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: ScreenUtil().screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF9FAFB),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF1555F3),
                                    size: 18,
                                  ),
                                  SizedBox(width: ScreenUtil().setSp(5)),
                                  Text(
                                    'Tondo, Manila',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsetsGeometry.all(15),
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Settings',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.notifications_none_outlined,
                                      color: Color(0xFF1555F3),
                                      size: 20,
                                    ),
                                    SizedBox(width: ScreenUtil().setSp(5)),
                                    Text(
                                      'Push Notifications',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: isSwitched1,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeThumbColor: Colors.white,
                                    activeTrackColor: Color(0xFF1555F3),
                                    inactiveThumbColor: Colors.white54,
                                    inactiveTrackColor: Color(0xFFE5E7EB),
                                    trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.white),
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched1 = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      color: Color(0xFF1555F3),
                                      size: 20,
                                    ),
                                    SizedBox(width: ScreenUtil().setSp(5)),
                                    Text(
                                      'SMS Alerts',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: isSwitched2,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeThumbColor: Colors.white,
                                    activeTrackColor: Color(0xFF1555F3),
                                    inactiveThumbColor: Colors.white54,
                                    inactiveTrackColor: Color(0xFFE5E7EB),
                                    trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.white),
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched2 = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shield_outlined,
                                      color: Color(0xFF1555F3),
                                      size: 20,
                                    ),
                                    SizedBox(width: ScreenUtil().setSp(5)),
                                    Text(
                                      'High Risk Alerts Only',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: isSwitched3,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeThumbColor: Colors.white,
                                    activeTrackColor: Color(0xFF1555F3),
                                    inactiveThumbColor: Colors.white54,
                                    inactiveTrackColor: Color(0xFFE5E7EB),
                                    trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.white),
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched3 = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsetsGeometry.all(15),
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(15)),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'Personal Information',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.person_outlined, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'Location Settings',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.location_on_outlined, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'Notification Preferences',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.notifications_outlined, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsetsGeometry.all(15),
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Health & Safety',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(15)),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'My Health Records',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.shield_outlined, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'Vaccination History',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.article_outlined, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'Saved Alerts',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.star_border_rounded, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsetsGeometry.all(15),
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Support',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(15)),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'Help Center',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.help_outline, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'Emergency Contacts',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.phone_outlined, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                            ListTile(
                              onTap: () {
                                
                              },
                              title: Text(
                                'About DOH Alert',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.info_outline, size: 20, color: Colors.black54),
                              trailing: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              visualDensity: VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          children: [
                            Text(
                              'FoodSafe Manila',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(5)),
                            Text(
                              'Version 1.0.0',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(5)),
                            Text(
                              'The Marauders',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    Card(
                      elevation: 0,
                      color: Color(0xFFFEF2F2),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Icon(Icons.exit_to_app, color: Colors.red,),
                              SizedBox(width: ScreenUtil().setSp(5)),
                              Text(
                                'Log Out',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    Card(
                      elevation: 0,
                      color: Color(0xFFEFF6FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Color(0xFFDBEAFE),
                          width: 1.5,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          children: [
                            Text(
                              'Your data is protected under the Data Privacy Act of 2012. We only use your location to send relevant health alerts.',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1980DD),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
