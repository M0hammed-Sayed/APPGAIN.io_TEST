import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetPopularMoviesUseCase {
  final MovieRepository repository;
  const GetPopularMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call() => repository.getPopularMovies();
}

class GetMovieDetailsUseCase {
  final MovieRepository repository;
  const GetMovieDetailsUseCase(this.repository);

  Future<MovieDetailsEntity> call(int id) => repository.getMovieDetails(id);
}
