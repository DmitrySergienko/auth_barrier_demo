import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio();

  static const _baseUrl = 'https://dev.barrier.ru';

  Future<Map<String, dynamic>> createUser(
      {required String userName,
      required String email,
      required String password,
      required bool agreed}) async {
    try {
      // Set the headers.
      _dio.options.headers['Content-Type'] = 'application/json';

      // Create the request.
      final response =
          await _dio.post('https://dev.barrier.ru/v1/users/users', data: {
        'first_name': userName,
        'email': email,
        'password': password,
        'is_agreed': agreed
      });

      if (response.statusCode == 201) {
        return {'status': 'success', 'message': response.data.toString()};
      } else {
        // Handle other status codes...
        return {
          'status': 'error',
          'message': '[Your error message based on the status code]'
        };
      }
    } catch (error) {
      print('Error during user creation: $error');
      return {
        'status': 'error',
        'message': 'Error during user creation: $error'
      };
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
