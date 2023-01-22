import 'package:flutter/material.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Account'),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}