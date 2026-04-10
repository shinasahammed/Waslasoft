import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waslasoft/models/payment_model.dart';
import 'package:waslasoft/services/sales_auth_service.dart';

class PaymentService {
  final Uri uri = Uri.https(
    "vansales.waslasoft.com",
    "/api/v1/payment_data/",
    {"client_code": "1999"},
  );

  /// Fetch list of payment entries
  Future<List<Paymentmodel>> fetchData() async {
    try {
      final response = await http.get(uri, headers: AuthService.headers);

      print("PAYMENT STATUS CODE: ${response.statusCode}");
      print("PAYMENT RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded.map((e) => Paymentmodel.fromJson(e)).toList();
        }

        if (decoded is Map && decoded.containsKey('data')) {
          return (decoded['data'] as List)
              .map((e) => Paymentmodel.fromJson(e))
              .toList();
        }

        throw Exception("Unexpected response format for Payment");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Fetch Error: $e");
    }
  }

  /// Post a new payment
  Future<bool> postData(Paymentmodel model) async {
    try {
      final response = await http.post(
        uri,
        headers: AuthService.headers,
        body: jsonEncode(model.toJson()),
      );

      print("POST PAYMENT STATUS CODE: ${response.statusCode}");
      print("POST PAYMENT RESPONSE BODY: ${response.body}");

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
