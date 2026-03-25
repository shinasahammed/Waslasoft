import 'dart:convert';

class AuthService {
  static const username = "naveen@techno.academy";
  static const password = "Gnusma\$1";

  static Map<String, String> get headers => {
        "Authorization":
            "Basic ${base64Encode(utf8.encode('$username:$password'))}",
        "Content-Type": "application/json",
      };
}