import '../../../domain/entities/movie_entity.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final MovieDetailsEntity movie;
  DetailsLoaded(this.movie);
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}
