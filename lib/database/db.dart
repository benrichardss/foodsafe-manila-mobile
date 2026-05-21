/*
import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class Database {
  static Db? db;
  static DbCollection? userCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create(mongoUri);
      await db!.open();

      userCollection = db!.collection(collectionName);

      log("Connected to MongoDB");
    } catch (e) {
      log("Error connecting to MongoDB: $e");
    }
  }

  static Future<Map<String, dynamic>?> login(
    String phone,
    String password,
  ) async {
    try {
      var user = await userCollection!.findOne({'phone_number': phone});

      if (user == null) {
        return null;
      }

      if (user['password'] == password) {
        return user; // return full user document
      }

      return null;
    } catch (e) {
      log("Login error: $e");
      return null;
    }
  }

  static Future<bool> registerUser({
    required String username,
    required String phone,
    required String password,
    String? email
  }) async {
    try {
      phone = phone.replaceAll(" ", "");

      var existingUser = await userCollection!.findOne({'phone_number': phone});

      // prevent duplicate phone numbers
      if (existingUser != null) {
        return false;
      }

      await userCollection!.insertOne({
        'username': username,
        'phone_number': phone,
        'password': password,
        'email': email ?? '',
        'created_at': DateTime.now(),
      });

      return true;
    } catch (e) {
      log("Register error: $e");
      return false;
    }
  }

  static Future<bool> updateUser({
    required ObjectId id,
    required String username,
    required String phone,
    String? email,
  }) async {
    try {
      phone = phone.replaceAll(" ", "");

      var modifier = modify
          .set('username', username)
          .set('phone_number', phone);

      if (email != null) {
        modifier = modifier.set('email', email);
      }

      var result = await userCollection!.updateOne(
        where.id(id),
        modifier,
      );

      return result.isSuccess;
    } catch (e) {
      log("Update error: $e");
      return false;
    }
  }

  static Future<bool> updatePassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      phone = phone.replaceAll(" ", "");

      var result = await userCollection!.updateOne(
        where.eq('phone_number', phone),
        modify.set('password', newPassword),
      );

      return result.isSuccess;
    } catch (e) {
      log("Update password error: $e");
      return false;
    }
  }

  static Future<bool> submitReport({
    required String reportId,
    required ObjectId reportedBy,
    required String reportLocation,
    required String symptoms,
    required String foodSource,
    required String foodLocation,
  }) async {
    try {
      var reportCollection = db!.collection('reports');

      await reportCollection.insertOne({
        'report_id': reportId,
        'reported_by': reportedBy,
        'report_location': reportLocation,
        'symptoms': symptoms,
        'food_source': foodSource,
        'food_location': foodLocation,
        'reported_at': DateTime.now(),
      });

      return true;
    } catch (e) {
      log("Submit report error: $e");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserReports(
    ObjectId userId,
  ) async {
    try {
      var reportCollection = db!.collection('reports');
      var reports = await reportCollection
          .find(where.eq('reported_by', userId))
          .toList();
      return reports;
    } catch (e) {
      log("Get reports error: $e");
      return [];
    }
  }

  static Future<DateTime?> getLastReportTime(ObjectId userId) async {
    try {
      var reportCollection = db!.collection('reports');

      final latestReport = await reportCollection
          .find(where.eq('reported_by', userId).sortBy('reported_at', descending: true).limit(1))
          .toList();

      if (latestReport.isEmpty) return null;

      return latestReport.first['reported_at'] as DateTime;
    } catch (e) {
      log("Get last report error: $e");
      return null;
    }
  }
}
*/