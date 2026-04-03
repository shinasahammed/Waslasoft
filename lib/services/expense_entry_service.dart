import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waslasoft/models/expense_entry_model.dart';
import 'package:waslasoft/services/sales_auth_service.dart';

class ExpenseEntryService {
  final Uri uri = Uri.https(
    "vansales.waslasoft.com",
    "/api/v1/expense_entry/",
    {"client_code": "1999"},
  );

  /// Fetch list of expense entries
  Future<List<Expenseentrymodel>> fetchData() async {
    try {
      final response = await http.get(uri, headers: AuthService.headers);

      print("EXPENSE ENTRY STATUS CODE: ${response.statusCode}");
      print("EXPENSE ENTRY RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded.map((e) => Expenseentrymodel.fromJson(e)).toList();
        }

        if (decoded is Map && decoded.containsKey('data')) {
          return (decoded['data'] as List)
              .map((e) => Expenseentrymodel.fromJson(e))
              .toList();
        }

        throw Exception("Unexpected response format for Expense Entry");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Fetch Error: $e");
    }
  }

  /// Post a new expense entry
  Future<bool> postData(Expenseentrymodel model) async {
    try {
      final response = await http.post(
        uri,
        headers: AuthService.headers,
        body: jsonEncode(model.toJson()),
      );

      print("POST STATUS CODE: ${response.statusCode}");
      print("POST RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Post Error: Server Error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Post Error: $e");
    }
  }
}
