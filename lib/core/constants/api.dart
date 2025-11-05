class Api {
  Api._();

  static const String baseUrl = 'https://nodes-iota.vercel.app/api';

  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  static const String grammarCheck = '/grammar/check';

  static String getEndpoint(String endpoint) {
    return '$baseUrl$endpoint';
  }
}

