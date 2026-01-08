import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'chat_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.value != null) {
      return ChatScreen(currentUserId: auth.value!.uid);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(authServiceProvider).signUp(_emailCtrl.text, _passCtrl.text);
                } catch (e) {
                  await ref.read(authServiceProvider).signIn(_emailCtrl.text, _passCtrl.text);
                }
              },
              child: const Text('Login / Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}