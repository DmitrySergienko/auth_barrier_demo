import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  static const _baseUrl = 'https://dev.barrier.ru';

  Future<void> createUser({
    required String userName,
    required String email,
    required String password,
    required bool isAgreed,
  }) async {
    final url = Uri.parse('$_baseUrl/users/users');
    final headers = {
      'Content-Type': 'application/json',
    };

    Future<String?> createUser() async {
      // Modify this URL to your server's endpoint
      final url = Uri.parse('https://dev.barrier.ru/users/users');

      // Setting headers
      final headers = {
        'Content-Type': 'application/json',
      };

      // Request body. Adjust the fields according to the API's requirements
      final body = json.encode({
        'first_name': userName,
        'email': email,
        'password': password,
        'is_agreed': isAgreed,
      });

      // Making the HTTP POST request
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        // Handle successful user creation
        final responseData = json.decode(response.body);
        // Для примера, покажем сообщение об успешном создании
        return null; // means success
      } else {
        // Handle errors
        final errorData = json.decode(response.body);
        // Для примера, покажем сообщение об ошибке (используем errorData для получения деталей ошибки)
        return 'Ошибка: ${errorData['message']}'; // Предполагаем, что сервер отправляет сообщение об ошибке в поле 'message'
      }
    }
  }

  Future<String?> authorizeUser({
    required String userName,
    required String email,
    required String password,
  }) async {
    final base64Credentials =
        base64Encode(utf8.encode('${userName}:${email}:${password}'));
    final headers = {
      'Authorization': 'Basic $base64Credentials',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('https://dev.barrier.ru/tokens/tokens'),
      headers: headers,
    );

    switch (response.statusCode) {
      case 200:
        // Успешная авторизация
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
        'Неизвестная ошибка: ${response.statusCode}';
        break;
    }
  }
}
