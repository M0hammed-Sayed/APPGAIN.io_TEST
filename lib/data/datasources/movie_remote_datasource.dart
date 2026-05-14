import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio _dio;

  MovieRemoteDataSource()
      : _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'accept': 'application/json',
        'Authorization': AppConstants.bearerToken,
      },
    ),
  ) {
    // Add logging interceptor in debug mode only
    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            log(' API Request: ${options.method} ${options.uri}');
            log(' Headers: ${options.headers}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            log(' API Response [${response.statusCode}]: ${response.requestOptions.uri}');
            log(' Body: ${response.data}');
            return handler.next(response);
          },
          onError: (error, handler) {
            log(' API Error: ${error.message}');
            log(' Error Response: ${error.response?.data}');
            return handler.next(error);
          },
        ),
      );
    }
  }

  Future<List<MovieModel>> getPopularMovies() async {
    final response = await _dio.get('movie/popular');
    final results = response.data['results'] as List<dynamic>;
    return results
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MovieDetailsModel> getMovieDetails(int id) async {
    final response = await _dio.get('movie/$id');
    return MovieDetailsModel.fromJson(
        response.data as Map<String, dynamic>);
  }
}