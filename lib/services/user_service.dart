import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const _baseUrl = 'https://dev.barrier.ru';

  Future<String?> createUser({
    required String userName,
    required String email,
    required String password,
    required bool isAgreed,
  }) async {
    final url = Uri.parse('$_baseUrl/users/users');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'first_name': userName,
      'email': email,
      'password': password,
      'is_agreed': isAgreed,
    });

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return null; // means success
    } else {
      final errorData = json.decode(response.body);
      return 'Ошибка: ${errorData['message']}';
    }
  }

  Future<String?> authorizeUser({
    required String userName,
    required String email,
    required String password,
  }) async {
    final base64Credentials =
        base64Encode(utf8.encode('${userName}:${password}')); // removed email
    final headers = {
      'Authorization': 'Basic $base64Credentials',
      'Content-Type': 'application/json',
    };

    final response =
        await http.get(Uri.parse('$_baseUrl/tokens/tokens'), headers: headers);

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
