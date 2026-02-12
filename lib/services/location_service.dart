import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class LocationService {
  static final loc.Location _location = loc.Location();

  // Synchronous cached value
  static String? cachedAddress;

  /// Preload location at app start
  static Future<void> preloadLocation() async {
    cachedAddress = await getUserAddress();
  }

  /// Handle permission + GPS service
  static Future<bool> _handlePermission() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  /// Get location (async)
  static Future<String> getUserAddress({bool forceRefresh = false}) async {
    if (cachedAddress != null && !forceRefresh) return cachedAddress!;

    final hasPermission = await _handlePermission();
    if (!hasPermission) return "Location permission denied";

    try {
      final locData = await _location.getLocation();

      if (locData.latitude == null || locData.longitude == null) {
        return "Location unavailable";
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(
        locData.latitude!,
        locData.longitude!,
      );

      if (placemarks.isEmpty) return "Unknown location";

      final place = placemarks.first;

      String city = place.locality ?? "";
      String district = place.subLocality ?? "";
      String country = place.country ?? "";

      String result = "";
      if (district.isNotEmpty) result += "$district, ";
      if (city.isNotEmpty) result += city;
      if (result.isEmpty) result = country;

      cachedAddress = result;
      return result;
    } catch (e) {
      return "Failed to get location";
    }
  }
}