import 'package:esflix/features/auth/domain/tmdb_session.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../assets/tmdb_constants.dart' as tmdb;
import '../application/authentification_tmdb_web_service.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  bool _isLoading = true;
  String? _exception;

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
      await AuthentificationTMDBWebService.createRequestToken();
      setState(() {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _buildBody(),
    );
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

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoading();
    } else if (_exception != null) {
      return _buildError();
    } else {
      var controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              CircularProgressIndicator(value: progress / 100);
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(
            Uri.parse("${tmdb.AUTH_URL}/${TmdbSession.requestToken}"));
      return WebViewWidget(controller: controller);
    }
  }
}
