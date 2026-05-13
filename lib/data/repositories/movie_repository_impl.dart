import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  const MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getPopularMovies() =>
      remoteDataSource.getPopularMovies();

  @override
  Future<MovieDetailsEntity> getMovieDetails(int id) =>
      remoteDataSource.getMovieDetails(id);
}
