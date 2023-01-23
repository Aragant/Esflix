import 'package:flutter/material.dart';

import '../../auth/presentation/login_web_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginWebView(),
            ),
          );
        },
        child: const Text('Login'),
      ),
    );
  }
}
