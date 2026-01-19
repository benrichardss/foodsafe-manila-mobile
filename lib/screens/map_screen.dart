import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(14.5995, 120.9842),
            initialCameraFit: CameraFit.coordinates(coordinates: <LatLng>[LatLng(14.5995, 120.9842)]),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.foodsafe_manila',
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => (Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
            Positioned(
              top: ScreenUtil().setSp(40),
              left: ScreenUtil().setSp(20),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Risk Levels',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(5)),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 15),
                          SizedBox(width: ScreenUtil().setSp(5)),
                          Text(
                            'High',
                            style: GoogleFonts.inter(
                              fontSize: 10
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.amber, size: 15),
                          SizedBox(width: ScreenUtil().setSp(5)),
                          Text(
                            'Moderate',
                            style: GoogleFonts.inter(
                              fontSize: 10
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 15),
                          SizedBox(width: ScreenUtil().setSp(5)),
                          Text(
                            'Low',
                            style: GoogleFonts.inter(
                              fontSize: 10
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}