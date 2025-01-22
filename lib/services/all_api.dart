import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://megameal.twilightparadox.com',
    ),
  );

  // GET request
  Future<Response> getModifierGroups({required int vendorId, required int page, required int pageSize}) async {
    try {
      final response = await _dio.get(
        '/pos/setting/modifier_group/',
        queryParameters: {
          'vendorId': vendorId,
          'page': page,
          'page_size': pageSize,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> createModifierGroup(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '/pos/setting/modifier_group/',
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> deleteModifierGroup({required int id, required int vendorId}) async {
    try {
      final response = await _dio.delete(
        '/pos/setting/modifier_group/$id/',
        queryParameters: {
          'vendorId': vendorId,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PATCH request
  Future<Response> updateModifierGroup({required int id, required int vendorId, required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.patch(
        '/pos/setting/modifier_group/$id/',
        queryParameters: {
          'vendorId': vendorId,
        },
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
