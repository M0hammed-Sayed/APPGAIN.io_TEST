import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/movie_remote_datasource.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/usecases/movie_usecases.dart';
import 'presentation/cubits/movies/movies_cubit.dart';
import 'presentation/screens/splash_screen.dart';

void main() => runApp(const CineScopeApp());

class CineScopeApp extends StatelessWidget {
  const CineScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency wiring (no service locator needed at this scale)
    final remoteDataSource = MovieRemoteDataSource();
    final repository = MovieRepositoryImpl(remoteDataSource);
    final getPopularMovies = GetPopularMoviesUseCase(repository);

    return BlocProvider(
      create: (_) => MoviesCubit(getPopularMovies),
      child: MaterialApp(
        title: 'CineScope',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
