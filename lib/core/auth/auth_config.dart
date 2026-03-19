import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthConfig {
  static const String _fallbackAccount = 'admin';
  static const String _fallbackPassword = '1230';

  static String get account =>
      _readEnv(key: 'LOGIN_ACCOUNT', fallback: _fallbackAccount);

  static String get password =>
      _readEnv(key: 'LOGIN_PASSWORD', fallback: _fallbackPassword);

  static bool validate({required String account, required String password}) {
    return account == AuthConfig.account && password == AuthConfig.password;
  }

  static String _readEnv({required String key, required String fallback}) {
    try {
      final String? value = dotenv.maybeGet(key);
      if (value == null || value.trim().isEmpty) {
        return fallback;
      }
      return value.trim();
    } catch (_) {
      return fallback;
    }
  }
}
