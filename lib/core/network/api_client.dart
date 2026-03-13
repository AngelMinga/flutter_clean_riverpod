import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio _dio = Dio();
  Future<Response> get(String url) async {
    try {
      return await _dio.get(url);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
