// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   static const String _loginUrl = 'https://reqres.in/api/login';
//
//   // Perform login
//   static Future<bool> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(_loginUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({"email": email, "password": password}),
//       );
//
//       if (response.statusCode == 200) {
//         // Assuming the API returns a token on successful login
//         final data = jsonDecode(response.body);
//         String token = data['token'];
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('token', token);
//         return true;
//       } else {
//         // Handle login failure
//         return false;
//       }
//     } catch (e) {
//       // Handle network or parsing errors
//       print(e);
//       return false;
//     }
//   }
//
//   // Perform logout
//   static Future<void> logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', false);
//     await prefs.remove('token');
//   }
// }
