import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/services/sales_auth_service.dart';

class ExpenseDataService {
  final Uri uri = Uri.https(
    "vansales.waslasoft.com",
    "/api/v1/expense_data/",
    {"client_code": "1999"},
  );

  /// Fetch list of expense data (parties/accounts)
  Future<List<Expensedatamodel>> fetchData() async {
    try {
      final response = await http.get(uri, headers: AuthService.headers);

      print("EXPENSE DATA STATUS CODE: ${response.statusCode}");
      print("EXPENSE DATA RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded.map((e) => Expensedatamodel.fromJson(e)).toList();
        }

        if (decoded is Map && decoded.containsKey('data')) {
          return (decoded['data'] as List)
              .map((e) => Expensedatamodel.fromJson(e))
              .toList();
        }

        throw Exception("Unexpected response format for Expense Data");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Fetch Error: $e");
    }
  }

  /// Helper to fetch just the names
  Future<List<String>> fetchNames() async {
    final data = await fetchData();
    return data
        .where((e) => e.name != null)
        .map((e) => e.name!)
        .toList();
  }

  /// Add a new expense party
  Future<Expensedatamodel?> createParty(String name, String openingBalance) async {
    try {
      final body = {
        "name": name,
        "open_balance": openingBalance,
        "typ": "EXPENSE",
      };

      final response = await http.post(
        uri,
        headers: AuthService.headers,
        body: jsonEncode(body),
      );

      print("CREATE PARTY STATUS CODE: ${response.statusCode}");
      print("CREATE PARTY RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
         final decoded = jsonDecode(response.body);
         if (decoded is Map<String, dynamic>) {
           return Expensedatamodel.fromJson(decoded);
         }
         return Expensedatamodel(name: name, openBalance: openingBalance, typ: "EXPENSE");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Create Party Error: $e");
    }
  }
}
