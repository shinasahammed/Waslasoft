import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sales_data_model.dart';
import '../models/purchase_data_model.dart' as purchase;
import '../models/purchase_return_model.dart' as p_return;

class TransactionStorage {
  static const String _salesKey = 'completed_sales_transactions';
  static const String _salesReturnKey = 'completed_sales_return_transactions';
  static const String _purchaseKey = 'completed_purchase_transactions';
  static const String _purchaseReturnKey = 'completed_purchase_return_transactions';

  /// Saves a new sales transaction to SharedPreferences
  static Future<void> saveSalesTransaction(Datum transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Datum> existing = await getSalesTransactions();
    
    // Add new transaction at the beginning
    existing.insert(0, transaction);
    
    final String encodedData = jsonEncode(
      existing.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_salesKey, encodedData);
  }

  /// Retrieves all completed sales transactions
  static Future<List<Datum>> getSalesTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_salesKey);

    if (encodedData != null) {
      try {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        return decodedData.map((item) => Datum.fromJson(item)).toList();
      } catch (e) {
        // Handle malformed cache
        return [];
      }
    }
    return [];
  }

  /// Clears all completed sales transactions (e.g. on sync)
  static Future<void> clearSalesTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_salesKey);
  }

  /// Saves a new sales return transaction to SharedPreferences
  static Future<void> saveSalesReturnTransaction(Datum transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Datum> existing = await getSalesReturnTransactions();
    
    // Add new transaction at the beginning
    existing.insert(0, transaction);
    
    final String encodedData = jsonEncode(
      existing.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_salesReturnKey, encodedData);
  }

  /// Retrieves all completed sales return transactions
  static Future<List<Datum>> getSalesReturnTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_salesReturnKey);

    if (encodedData != null) {
      try {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        return decodedData.map((item) => Datum.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  /// Clears all completed sales return transactions
  static Future<void> clearSalesReturnTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_salesReturnKey);
  }

  /// Saves a new purchase transaction to SharedPreferences
  static Future<void> savePurchaseTransaction(purchase.Datum transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<purchase.Datum> existing = await getPurchaseTransactions();
    
    // Add new transaction at the beginning
    existing.insert(0, transaction);
    
    final String encodedData = jsonEncode(
      existing.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_purchaseKey, encodedData);
  }

  /// Retrieves all completed purchase transactions
  static Future<List<purchase.Datum>> getPurchaseTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_purchaseKey);

    if (encodedData != null) {
      try {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        return decodedData.map((item) => purchase.Datum.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  /// Clears all completed purchase transactions
  static Future<void> clearPurchaseTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_purchaseKey);
  }

  /// Saves a new purchase return transaction to SharedPreferences
  static Future<void> savePurchaseReturnTransaction(p_return.Datum transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<p_return.Datum> existing = await getPurchaseReturnTransactions();
    
    // Add new transaction at the beginning
    existing.insert(0, transaction);
    
    final String encodedData = jsonEncode(
      existing.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_purchaseReturnKey, encodedData);
  }

  /// Retrieves all completed purchase return transactions
  static Future<List<p_return.Datum>> getPurchaseReturnTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_purchaseReturnKey);

    if (encodedData != null) {
      try {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        return decodedData.map((item) => p_return.Datum.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  /// Clears all completed purchase return transactions
  static Future<void> clearPurchaseReturnTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_purchaseReturnKey);
  }
}
