import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sales_return_model.dart';

class SalesReturnStorage {
  static const String _key = 'cached_sales_return_items';

  /// Saves a list of SalesReturn objects to SharedPreferences.
  static Future<void> saveSalesReturns(List<SalesReturnItem> returns) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      returns.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  /// Retrieves a list of SalesReturn objects from SharedPreferences.
  static Future<List<SalesReturnItem>> getSalesReturns() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((item) => SalesReturnItem.fromJson(item)).toList();
    }
    return [];
  }

  /// Clears the cached sales items.
  static Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
