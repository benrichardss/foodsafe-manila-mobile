import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class Database {
  static Db? db;
  static DbCollection? userCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create(MONGO_URI);
      await db!.open();

      userCollection = db!.collection(COLLECTION_NAME);

      log("Connected to MongoDB");
    } catch (e) {
      log("Error connecting to MongoDB: $e");
    }
  }

  static Future<Map<String, dynamic>?> login(String phone, String password) async {
    try {
      var user = await userCollection!.findOne({
        'phone_number': phone,
      });

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
    required String firstName,
    required String lastName,
    required String sex,
    required String phone,
    required String password,
  }) async {
    try {
      phone = phone.replaceAll(" ", "");
      
      var existingUser = await userCollection!.findOne({
        'phone_number': phone,
      });

      // prevent duplicate phone numbers
      if (existingUser != null) {
        return false;
      }

      await userCollection!.insertOne({
        'first_name': firstName,
        'last_name': lastName,
        'sex': sex,
        'phone_number': phone,
        'password': password,
        'created_at': DateTime.now(),
      });

      return true;
    } catch (e) {
      log("Register error: $e");
      return false;
    }
  }
}