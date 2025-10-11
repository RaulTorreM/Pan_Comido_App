import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? 'http://192.168.0.71:8000/api',
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  String? _token;

  // Inicializa el token guardado (si existe)
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('api_token');
    if (_token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    }
  }

  // 🔐 LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];

        if (token != null) {
          _token = token;
          _dio.options.headers['Authorization'] = 'Bearer $token';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('api_token', token);
        }

        return data;
      } else {
        throw Exception('Error al iniciar sesión');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Credenciales incorrectas';
      throw Exception(message);
    }
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } catch (_) {
      // Ignorar error del logout
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('api_token');
      _token = null;
      _dio.options.headers.remove('Authorization');
    }
  }

  // 📡 Método general GET
  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en la solicitud GET');
    }
  }

  // 📡 Método general POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en la solicitud POST');
    }
  }
}
