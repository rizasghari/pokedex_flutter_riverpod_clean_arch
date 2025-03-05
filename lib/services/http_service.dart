import 'package:dio/dio.dart';
import 'package:flutter/material.dart'
;
class HttpService {
  HttpService();

  final _dio = Dio();

  Future<Response?> get(String path) async {
    try {
     Response res = await _dio.get(path);
     return res;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
