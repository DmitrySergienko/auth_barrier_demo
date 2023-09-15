import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const _baseUrl = 'https://dev.barrier.ru';

  Future<String?> createUser({
    required String firstName,
    required String email,
    required String password,
    required bool isAgreed,
  }) async {
    final url = Uri.parse('$_baseUrl/v1/users/users');

    final body = utf8.encode(json.encode({
      'first_name': 'TestName',
    }));

    try {
      var response = await http.post(url,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=utf-8'
          },
          body: body);

      print('status code: ${response.statusCode}');

      if (response.statusCode == 201) {
        return null; // Success
      } else {
        // Return error message or description based on the status code
        return 'HTTP error: ${response.statusCode}. Response body: ${response.body}';
      }
    } catch (e) {
      print('Error: $e');
      return 'Unexpected error: $e';
    }
  }

  Future<String?> authorizeUser({
    required String userName,
    required String email,
    required String password,
  }) async {
    final base64Credentials = base64Encode(utf8.encode('${email}:${password}'));

    final headers = {
      'Authorization': 'Basic $base64Credentials',
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('$_baseUrl/v1/tokens/tokens'),
        headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    switch (response.statusCode) {
      case 200:
        final responseData = json.decode(response.body);
        return 'Успешная авторизация:  $responseData';
      case 400:
        return 'Проблема в формате почты';
      case 401:
        return 'Проблемы с авторизационными данными';
      case 416:
        return 'Неверная длина пароля или имени пользователя.';
      case 418:
        return 'Пароль слишком легкий';
      case 422:
        return 'В запросе не хватает данных';
      case 423:
        return 'Пользователь заблокирован';
      case 456:
        return 'Проблемы с базой данных';
      default:
        return 'Неизвестная ошибка: ${response.statusCode}';
    }
  }
}
