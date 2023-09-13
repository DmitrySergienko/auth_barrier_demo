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
    final result = await userService.createUser(
      userName: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      isAgreed: _isAgreedController.value,
    );
  }

  void _handleCreateAuth() {
    userService.authorizeUser(
      userName: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
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
                decoration: const InputDecoration(
                    labelText: 'Пароль')), // Изменил текст метки на русский
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