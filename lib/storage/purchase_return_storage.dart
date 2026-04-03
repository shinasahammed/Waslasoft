import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/purchase_return_model.dart';

class PurchaseReturnStorage {
  static const String _key = 'cached_purchase_return_items';

  /// Saves a list of PurchaseReturn objects to SharedPreferences.
  static Future<void> savePurchaseReturns(List<PurchaseReturnItem> returns) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      returns.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  /// Retrieves a list of PurchaseReturn objects from SharedPreferences.
  static Future<List<PurchaseReturnItem>> getPurchaseReturns() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((item) => PurchaseReturnItem.fromJson(item)).toList();
    }
    return [];
  }

  /// Clears the cached sales items.
  static Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
