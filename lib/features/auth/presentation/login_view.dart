import 'package:esflix/features/account/presentation/account_detail_view.dart';
import 'package:esflix/features/auth/application/auth_tmdb_service.dart';
import 'package:esflix/features/auth/presentation/login_form_view.dart';
import 'package:flutter/material.dart';


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
    return AccountDetailView(onLogout: updateLog);
  }

  Widget _buildNotLogged() {
    return LoginFormView(
      onLogin: updateLog,
    );
  }

  void updateLog() {
    setState(() {});
  }
}
