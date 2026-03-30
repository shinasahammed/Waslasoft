import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:waslasoft/models/purchase_data_model.dart';

import 'package:waslasoft/services/sales_auth_service.dart';

class PurchaseDataService {
  final Uri uri = Uri.https("vansales.waslasoft.com", "/api/v1/purchase_data/", {
    "client_code": "1999",
  });

  Future<List<PurchaseItem>> fetchData() async {
    try {
      final response = await http.get(uri, headers: AuthService.headers);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // if API returns list directly
        if (decoded is List) {
          return decoded.map((e) => PurchaseItem.fromJson(e)).toList();
        }

        // if API returns wrapped response (common case)
        if (decoded is Map && decoded.containsKey('data')) {
          final List<Datum> datums = (decoded['data'] as List)
              .map((e) => Datum.fromJson(e))
              .toList();
          
          // Filter out orders without items and flatten all purchaseItems into a single list
          return datums
              .expand((datum) => datum.purchaseItems ?? <PurchaseItem >[])
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
