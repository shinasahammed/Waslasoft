import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waslasoft/models/purchase_model.dart';
import 'auth_service.dart'; // import this

class PurchaseService {
  final uri = Uri.http(
    "vansales.waslasoft.com",
    "/api/v1/products_data/",
    {"client_code": "2029"},
  );

  Future<List<Purchasemodel>> fetchData() async {
    final response = await http.get(
      uri,
      headers: AuthService.headers, 
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Purchasemodel.fromJson(e)).toList();
    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  }
}