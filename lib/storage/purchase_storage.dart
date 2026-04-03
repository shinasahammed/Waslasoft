import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/purchase_data_model.dart';

class PurchaseStorage {
  static const String _key = 'cached_purchase_items';

  /// Saves a list of PurchaseItem objects to SharedPreferences.
  static Future<void> savePurchaseItems(List<PurchaseItem> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  /// Retrieves a list of PurchaseItem objects from SharedPreferences.
  static Future<List<PurchaseItem>> getPurchaseItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((item) => PurchaseItem.fromJson(item)).toList();
    }
    return [];
  }

  /// Clears the cached sales items.
  static Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
