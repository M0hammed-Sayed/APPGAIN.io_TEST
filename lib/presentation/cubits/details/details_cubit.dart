import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/movie_usecases.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final GetMovieDetailsUseCase _getMovieDetails;

  DetailsCubit(this._getMovieDetails) : super(DetailsInitial());

  Future<void> fetchDetails(int id) async {
    try {
      emit(DetailsLoading());
      final movie = await _getMovieDetails(id);
      emit(DetailsLoaded(movie));
    } catch (e) {
      emit(DetailsError(e.toString()));
    }
  }
}
