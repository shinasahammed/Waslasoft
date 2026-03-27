import 'dart:convert';

class AuthService {
  static const username = "akshay@technostore360.com";
  static const password = "Gnusma\$1";

  static Map<String, String> get headers => {
        "Authorization":
            "Basic ${base64Encode(utf8.encode('$username:$password'))}",
        "Content-Type": "application/json",
      };
}