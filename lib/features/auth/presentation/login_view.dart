import 'package:esflix/features/auth/application/auth_tmdb_service.dart';
import 'package:esflix/features/auth/presentation/login_form_view.dart';
import 'package:flutter/material.dart';

import 'login_web_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    if (AuthTmdbService.isLogged()) {
      return _buildLogged();
    } else {
      return _buildNotLogged();
    }
  }

  Widget _buildLogged() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You are logged in'),
          ElevatedButton(
            onPressed: () {
              AuthTmdbService.logout();
              setState(() {});
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLogged() {
    return LoginFormView(
      onLogin: login,
    );
  }

  void login() {
    setState(() {});
  }
}
