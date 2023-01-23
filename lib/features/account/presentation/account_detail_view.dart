import 'package:esflix/features/account/application/account_tmdb_web_service.dart';
import 'package:esflix/features/auth/application/auth_tmdb_service.dart';
import 'package:flutter/material.dart';

import '../domain/account.dart';
import '../../../assets/tmdb_constants.dart' as tmdb;


// A stateful widget who retrieve account detail with a username and a profile picture.
class AccountDetailView extends StatefulWidget {
  final VoidCallback onLogout;

  const AccountDetailView({super.key, required this.onLogout});

  @override
  State<AccountDetailView> createState() => _AccountDetailViewState();
}

class _AccountDetailViewState extends State<AccountDetailView> {
  bool _isLoading = true;
  String? _exception;
  Account _account = Account.empty();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final account = await AccountTmdbWebService.getDetails();
      setState(() {
        _account = account;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _exception = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text(_exception.toString()),
    );
  }

  Widget _buildAccount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildAvatar(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_account.username,),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        await AuthTmdbService.logout();
                        widget.onLogout();
                      },
                      icon: const Icon(Icons.logout)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoading();
    } else if (_exception != null) {
      return _buildError();
    } else {
      return _buildAccount();
    }
  }

  Widget _buildAvatar() {
    if (_account.avatarPath != null) {
      // profile picture in a circle
      return CircleAvatar(
        backgroundImage: NetworkImage('${tmdb.IMAGE_URL}/${_account.avatarPath!}'),
      );
    } else {
      return const Icon(Icons.account_circle);
    }
  }
}
