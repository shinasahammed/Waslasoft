import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:waslasoft/models/purchase_return_model.dart';

import 'package:waslasoft/services/sales_auth_service.dart';

class PurchaseReturnService {
  final Uri uri = Uri.https(
    "vansales.waslasoft.com",
    "/api/v1/purchase_return_data/",
    {"client_code": "1999"},
  );

  Future<List<PurchaseReturnItem>> fetchData() async {
    try {
      final response = await http.get(uri, headers: AuthService.headers);
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);

        if (decode is Map && decode.containsKey('data')) {
          final List<Datum> datums = (decode['data'] as List)
              .map((e) => Datum.fromJson(e))
              .toList();

          return datums
              .expand(
                (datum) => datum.purchaseReturnItems ?? <PurchaseReturnItem>[],
              )
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
