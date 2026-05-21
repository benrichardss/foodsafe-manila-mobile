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

  /// Convert Manila area into District
  static String getManilaDistrict(String area) {
    area = area.toLowerCase();

    // First District
    if (area.contains("tondo")) {
      if (area.contains("north harbor")) {
        return "First District – Tondo 1";
      }
      return "Second District";
    }

    // Third District
    if (area.contains("san nicolas") ||
        area.contains("binondo") ||
        area.contains("quiapo") ||
        area.contains("santa cruz") ||
        area.contains("sta cruz")) {
      return "Third District";
    }

    // Fourth District
    if (area.contains("sampaloc")) {
      return "Fourth District";
    }

    // Fifth District
    if (area.contains("malate") ||
        area.contains("ermita") ||
        area.contains("intramuros") ||
        area.contains("port area") ||
        area.contains("south harbor") ||
        area.contains("paco") ||
        area.contains("san andres")) {
      return "Fifth District";
    }

    // Sixth District
    if (area.contains("pandacan") ||
        area.contains("san miguel") ||
        area.contains("sta. ana") ||
        area.contains("santa ana") ||
        area.contains("sta mesa") ||
        area.contains("sta. mesa") ||
        area.contains("santa mesa")) {
      return "Sixth District";
    }

    return "Unknown District";
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

      String barangay = place.subLocality ?? "";
      String area = place.locality ?? "";

      // Some Manila locations appear in subAdministrativeArea
      if (area.isEmpty) {
        area = place.subAdministrativeArea ?? "";
      }

      String district = getManilaDistrict(area);

      List<String> parts = [];

      if (barangay.isNotEmpty) {
        parts.add(barangay);
      }

      if (district != "Unknown District") {
        parts.add(district);
      } else if (area.isNotEmpty) {
        parts.add(area);
      }

      String result = parts.join(", ");

      cachedAddress = result;
      return result;
    } catch (e) {
      return "Failed to get location";
    }
  }

  /// Get the current latitude/longitude as a map.
  static Future<Map<String, double>?> getCurrentCoordinates() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    try {
      final locData = await _location.getLocation();

      if (locData.latitude == null || locData.longitude == null) {
        return null;
      }

      return {
        'lat': locData.latitude!,
        'lng': locData.longitude!,
      };
    } catch (e) {
      return null;
    }
  }
}