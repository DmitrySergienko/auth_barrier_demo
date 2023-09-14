import 'package:auth_barrier_demo/services/user_service.dart';
import 'package:flutter/material.dart';

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

  void _handleCreateUser() async {
    try {
      final result = await userService.createUser(
        firstName: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        isAgreed: _isAgreedController.value,
      );

      if (result == null) {
        // User creation was successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пользователь успешно создан!')),
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

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree.
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _isAgreedController.dispose();
    super.dispose();
  }
}
