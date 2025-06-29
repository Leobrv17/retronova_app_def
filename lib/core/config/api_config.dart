class ApiConfig {
  static const String baseUrl = 'https://www.retronova.fr/api/v1';

  // Endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String register = '$auth/register';
  static const String me = '$auth/me';
  static const String updateProfile = '$users/me';

  // Headers
  static Map<String, String> getHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}