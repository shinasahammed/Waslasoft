import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/services/sales_auth_service.dart';

class SupplierDataService {
  final Uri uri = Uri.https("vansales.waslasoft.com", "/api/v1/supplier_data/", {
    "client_code": "1999",
  });

  /// Fetch list of supplier data
  Future<List<Expensedatamodel>> fetchData() async {
    try {
      final response = await http.get(uri, headers: AuthService.headers);

      print("SUPPLIER DATA STATUS CODE: ${response.statusCode}");
      print("SUPPLIER DATA RESPONSE BODY: ${response.body}");

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

        throw Exception("Unexpected response format for Supplier Data");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Fetch Error: $e");
    }
  }

  /// Create a new supplier
  Future<Expensedatamodel?> createSupplier({
    required String name,
    required String openingBalance,
  }) async {
    try {
      final body = {
        "supplier_name": name,
        "open_balance": openingBalance,
      };

      final response = await http.post(
        uri,
        headers: AuthService.headers,
        body: jsonEncode(body),
      );

      print("CREATE SUPPLIER STATUS CODE: ${response.statusCode}");
      print("CREATE SUPPLIER RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return Expensedatamodel.fromJson(decoded);
        }
        return Expensedatamodel(
          name: name,
          openBalance: openingBalance,
        );
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Create Supplier Error: $e");
    }
  }
}
