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

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'first_name': firstName,
      'email': email,
      'password': password,
      'is_agreed': isAgreed,
    });

    var client = http.Client();
    try {
      var response = await client.post(url, headers: headers, body: body);

      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          var decodedResponse =
              jsonDecode(utf8.decode(response.bodyBytes)) as Map;
          if (decodedResponse.containsKey('uri')) {
            var uri = Uri.parse(decodedResponse['uri'] as String);

            print(await client.get(uri));
          } else {
            print('URI key not found in the response.');
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          print('Response body: ${response.body}');
        }
      } else {
        print(
            'HTTP error: ${response.statusCode}. Response body: ${response.body}');
      }
    } finally {
      client.close();
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
