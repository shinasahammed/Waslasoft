import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final response = await http.get(Uri.parse("http://vansales.waslasoft.com/api/v1/products_data/?client_code=2029"));
    print('Status: ${response.statusCode}');
    if (response.body.length > 200) {
      print('Body start: ${response.body.substring(0, 200)}');
    } else {
      print('Body: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
