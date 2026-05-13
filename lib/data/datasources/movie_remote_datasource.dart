import 'package:dio/dio.dart';
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
        );

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
