import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  bool isLoading = true;
  LatLng? _currentLocation;

  @override
  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (!await _checktheRequestPermissions()) return;

    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
          isLoading = false;
        });
      }
    });
  }

  Future<bool> _checktheRequestPermissions() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current location not available.')),
      );
    }
  }

  final List<RiskLocation> riskLocations = [
    RiskLocation(
      position: LatLng(14.5995, 120.9842),
      virus: 'Salmonella',
      location: 'Barangay 123, Tondo',
      riskLevel: 'High Risk',
      description:
          'Multiple reported Salmonella cases linked to improperly stored street food.',
      numOfCases: 45,
      color: Colors.red,
    ),
    RiskLocation(
      position: LatLng(14.6091, 120.9716),
      virus: 'E. coli',
      location: 'Barangay 456, Sampaloc',
      riskLevel: 'High Risk',
      description:
          'Confirmed E. coli outbreak associated with contaminated water used in food preparation.',
      numOfCases: 38,
      color: Colors.red,
    ),
    RiskLocation(
      position: LatLng(14.5833, 120.9822),
      virus: 'Norovirus',
      location: 'Barangay 702, Malate',
      riskLevel: 'High Risk',
      description:
          'Rapid spread of Norovirus linked to shared dining facilities.',
      numOfCases: 41,
      color: Colors.red,
    ),
    RiskLocation(
      position: LatLng(14.6042, 120.9822),
      virus: 'Food Poisoning',
      location: 'Barangay 296, Binondo',
      riskLevel: 'Moderate Risk',
      description:
          'Several food poisoning cases reported after dining at local eateries.',
      numOfCases: 18,
      color: Colors.amber,
    ),
    RiskLocation(
      position: LatLng(14.5896, 120.9754),
      virus: 'Campylobacter',
      location: 'Barangay 812, Paco',
      riskLevel: 'Moderate Risk',
      description:
          'Campylobacter cases suspected from undercooked poultry products.',
      numOfCases: 14,
      color: Colors.amber,
    ),
    RiskLocation(
      position: LatLng(14.5700, 120.9860),
      virus: 'Salmonella',
      location: 'Barangay 833, Pandacan',
      riskLevel: 'Moderate Risk',
      description:
          'Intermittent Salmonella infections reported over the past two weeks.',
      numOfCases: 21,
      color: Colors.amber,
    ),
    RiskLocation(
      position: LatLng(14.5906, 120.9798),
      virus: 'Norovirus',
      location: 'Barangay 567, Quiapo',
      riskLevel: 'Low Risk',
      description:
          'Isolated Norovirus cases with no ongoing community transmission.',
      numOfCases: 3,
      color: Colors.green,
    ),
    RiskLocation(
      position: LatLng(14.6226, 120.9756),
      virus: 'Food Poisoning',
      location: 'Barangay 591, Santa Mesa',
      riskLevel: 'Low Risk',
      description:
          'Minor food poisoning cases reported and quickly resolved.',
      numOfCases: 5,
      color: Colors.green,
    ),
    RiskLocation(
      position: LatLng(14.5622, 120.9956),
      virus: 'E. coli',
      location: 'Barangay 874, San Andres Bukid',
      riskLevel: 'Low Risk',
      description:
          'Low number of E. coli cases under monitoring by local health units.',
      numOfCases: 7,
      color: Colors.green,
    ),
  ];

  Color lighten(Color color, [double amount = 0.85]) {
    return Color.lerp(color, Colors.white, amount)!;
  }

  double markerSizeForCases(int cases) {
    const double minSize = 24;
    const double maxSize = 48;

    final maxCases = riskLocations
        .map((e) => e.numOfCases)
        .reduce((a, b) => a > b ? a : b);

    if (maxCases == 0) return minSize;

    return minSize + (cases / maxCases) * (maxSize - minSize);
  }

  void _showLocationCard(RiskLocation location) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: lighten(location.color),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: location.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.virus,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            location.location,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => Navigator.pop(context),
                      visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: lighten(location.color),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: location.color, width: 0.5),
                      ),
                      child: Text(
                        location.riskLevel,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: location.color
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${location.numOfCases} cases',
                      style: GoogleFonts.inter(
                        color: Colors.black54,
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFF1980DD),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          location.description,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF1980DD),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Get Directions",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "View Details",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(14.5995, 120.9842),
            initialZoom: 14,
            maxZoom: 20,
            cameraConstraint: CameraConstraint.containLatitude(),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.foodsafe_manila',
            ),
            MarkerLayer(
              markers: riskLocations.map((location) {
                final size = markerSizeForCases(location.numOfCases);
                return Marker(
                  child: InkWell(
                    onTap: () {
                      _showLocationCard(location);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: location.color.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  width: size,
                  height: size,
                  point: location.position,
                );
              }).toList(),
            ),
            CurrentLocationLayer(
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(),
                markerSize: Size(20, 20),
                markerDirection: MarkerDirection.heading,
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Risk Levels',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(5)),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 15),
                          SizedBox(width: ScreenUtil().setSp(5)),
                          Text('High', style: GoogleFonts.inter(fontSize: 10)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.amber, size: 15),
                          SizedBox(width: ScreenUtil().setSp(5)),
                          Text(
                            'Moderate',
                            style: GoogleFonts.inter(fontSize: 10),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 15),
                          SizedBox(width: ScreenUtil().setSp(5)),
                          Text('Low', style: GoogleFonts.inter(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isLoading
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1555F3),
                          padding: EdgeInsets.all(10),
                          strokeWidth: 2,
                        ),
                      )
                    : InkWell(
                        onTap: _userCurrentLocation,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.my_location,
                            color: Color(0xFF1555F3),
                          ),
                        ),
                      ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  width: double.infinity,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Outbreaks',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '2',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Spacer(flex: 1),
                        VerticalDivider(),
                        Spacer(flex: 1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Moderate',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '2',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.amber,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Spacer(flex: 1),
                        VerticalDivider(),
                        Spacer(flex: 1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Cases',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '91',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () =>
                      (Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class RiskLocation {
  final LatLng position;
  final String virus, location, riskLevel, description;
  final int numOfCases;
  final Color color;

  RiskLocation({
    required this.position,
    required this.virus,
    required this.location,
    required this. riskLevel,
    required this.description,
    required this.numOfCases,
    required this.color,
  });
}
