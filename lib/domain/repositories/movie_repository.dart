import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getPopularMovies();
  Future<MovieDetailsEntity> getMovieDetails(int id);
}
