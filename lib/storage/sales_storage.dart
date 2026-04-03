import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sales_data_model.dart';

class SalesStorage {
  static const String _key = 'cached_sales_items';

  /// Saves a list of SaleItem objects to SharedPreferences.
  static Future<void> saveSalesItems(List<SaleItem> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  /// Retrieves a list of SaleItem objects from SharedPreferences.
  static Future<List<SaleItem>> getSalesItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((item) => SaleItem.fromJson(item)).toList();
    }
    return [];
  }

  /// Clears the cached sales items.
  static Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
