import 'package:flutter/material.dart';
import 'package:mealtime/core/auth/auth_config.dart';
import 'package:mealtime/features/auth/presentation/widgets/entrance_section.dart';
import 'package:mealtime/features/auth/presentation/widgets/login_form.dart';
import 'package:mealtime/features/auth/presentation/widgets/login_header.dart';
import 'package:mealtime/features/auth/presentation/widgets/third_party_login_section.dart';
import 'package:mealtime/features/home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showHeader = false;
  bool _showForm = false;
  bool _showFooter = false;
  bool _isSubmitting = false;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _startEntranceAnimation();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _startEntranceAnimation() {
    Future<void>.delayed(
      const Duration(milliseconds: 60),
      () => _updateIfMounted(() => _showHeader = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 160),
      () => _updateIfMounted(() => _showForm = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 280),
      () => _updateIfMounted(() => _showFooter = true),
    );
  }

  void _updateIfMounted(VoidCallback callback) {
    if (!mounted) {
      return;
    }
    setState(callback);
  }

  Future<void> _submitLogin() async {
    if (_isSubmitting) {
      return;
    }

    final String account = _accountController.text.trim();
    final String password = _passwordController.text;

    _updateIfMounted(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (!mounted) {
      return;
    }

    final bool valid = AuthConfig.validate(
      account: account,
      password: password,
    );
    if (valid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('登录成功')));
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('账号或密码错误，请重试')));
    }

    _updateIfMounted(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EntranceSection(
                      visible: _showHeader,
                      child: const LoginHeader(),
                    ),
                    EntranceSection(
                      visible: _showForm,
                      child: LoginForm(
                        accountController: _accountController,
                        passwordController: _passwordController,
                        isSubmitting: _isSubmitting,
                        isButtonPressed: _isButtonPressed,
                        onTapDown: (_) =>
                            _updateIfMounted(() => _isButtonPressed = true),
                        onTapUp: (_) =>
                            _updateIfMounted(() => _isButtonPressed = false),
                        onTapCancel: () =>
                            _updateIfMounted(() => _isButtonPressed = false),
                        onSubmit: _submitLogin,
                      ),
                    ),
                    EntranceSection(
                      visible: _showFooter,
                      child: const ThirdPartyLoginSection(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
