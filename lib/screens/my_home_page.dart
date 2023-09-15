import 'package:auth_barrier_demo/data/user.dart';
import 'package:auth_barrier_demo/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String BASE_URL = 'https://dev.barrier.ru/v1/users/users';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _isAgreedController = ValueNotifier<bool>(true);
  final userService = UserService();

  Future<void> _handleCreateUser() async {
    final newUser = await createUser(
      firstName: 'TestName3',
      email: 'new_user@example3.com',
      password: 'dfsdsfs3Er',
      isAgreed: true,
    );

    if (newUser != null) {
      print('User created with ID: ${newUser.userId}');
    }
  }

  Future<User?> createUser({
    required String firstName,
    required String email,
    required String password,
    required bool isAgreed,
  }) async {
    final response = await http.post(
      Uri.parse(BASE_URL),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'first_name': firstName,
        'email': email,
        'password': password,
        'is_agreed': isAgreed,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return User.fromJson(data['user']);
    } else {
      print('Failed to create user with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  Future<String> _getUserList() async {
    var url = Uri.parse('https://dev.barrier.ru/v1/users/users');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch user list');
    }
  }

  void _handleCreateAuth() async {
    try {
      final result = await userService.authorizeUser(
        userName: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result == null) {
        // Authorization was successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Авторизация прошла успешно!')),
        );
      } else {
        // Something went wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    } catch (error) {
      // Unexpected error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неизвестная ошибка: $error')),
      );
      print('Неизвестная ошибка: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pure Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Имя')),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
              controller: _passwordController,
              obscureText: false,
              decoration: const InputDecoration(labelText: 'Пароль'),
            ),
            CheckboxListTile(
              title: const Text('Согласие на обработку данных'),
              value: _isAgreedController.value,
              onChanged: (value) => _isAgreedController.value = value!,
            ),
            ElevatedButton(
                onPressed: _handleCreateUser,
                child: const Text('Создать пользователя')),
            ElevatedButton(
                onPressed: _handleCreateAuth,
                child: const Text('Авторизовать')),
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   // Clean up the controllers when the widget is removed from the widget tree.
  //   _usernameController.dispose();
  //   _passwordController.dispose();
  //   _emailController.dispose();
  //   _isAgreedController.dispose();
  //   super.dispose();
  // }
}
