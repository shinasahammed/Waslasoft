import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waslasoft/models/purchase_model.dart';
import 'auth_service.dart';

class PurchaseService {
  final Uri uri = Uri.https(
    "vansales.waslasoft.com",
    "/api/v1/products_data/",
    {"client_code": "2029"},
  );

  Future<List<Purchasemodel>> fetchData() async {
    try {
      final response = await http.get(uri, headers: AuthService.headers);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // if API returns list directly
        if (decoded is List) {
          return decoded.map((e) => Purchasemodel.fromJson(e)).toList();
        }

        // if API returns wrapped response (common case)
        if (decoded is Map && decoded.containsKey('data')) {
          return (decoded['data'] as List)
              .map((e) => Purchasemodel.fromJson(e))
              .toList();
        }

        throw Exception("Unexpected response format");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Fetch Error: $e");
    }
  }
}
