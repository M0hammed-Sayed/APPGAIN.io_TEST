import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/movie_usecases.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final GetPopularMoviesUseCase _getPopularMovies;
  bool _fetched = false;

  MoviesCubit(this._getPopularMovies) : super(MoviesInitial());

  /// Only fetches once; subsequent calls are no-ops.
  Future<void> fetchPopularMovies() async {
    if (_fetched) return;
    try {
      emit(MoviesLoading());
      final movies = await _getPopularMovies();
      _fetched = true;
      emit(MoviesLoaded(movies));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  void reset() {
    _fetched = false;
    emit(MoviesInitial());
  }
}
