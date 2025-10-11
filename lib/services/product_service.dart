import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class ProductService {
  late final Dio _dio;

  ProductService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? 'http://192.168.0.71:8000/api',
        connectTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para añadir token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('api_token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Si el token expiró, puedes manejarlo aquí
          if (e.response?.statusCode == 401) {
            throw Exception('Token inválido o expirado. Por favor, inicia sesión nuevamente.');
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// 🔹 Obtener lista de productos (con filtros opcionales)
  Future<List<Product>> getProducts({String? category, String? search}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          if (category != null && category.isNotEmpty) 'category': category,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);

      return data.map<Product>((item) => Product.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener productos');
    }
  }

  /// 🔹 Obtener un solo producto por ID
  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener producto');
    }
  }
}
