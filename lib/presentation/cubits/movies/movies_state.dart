import '../../../domain/entities/movie_entity.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<MovieEntity> movies;
  MoviesLoaded(this.movies);
}

class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}
