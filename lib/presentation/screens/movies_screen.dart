import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/movie_entity.dart';
import '../cubits/movies/movies_cubit.dart';
import '../cubits/movies/movies_state.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    // Safe: cubit guard prevents duplicate calls
    context.read<MoviesCubit>().fetchPopularMovies();
  }

  void _openDetails(BuildContext context, MovieEntity movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailsScreen(movieId: movie.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(
          AppConstants.appName,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: r.sp(22),
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: r.w(16)),
            child: const Icon(Icons.search, color: AppTheme.textSecondary),
          ),
        ],
      ),
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          }

          if (state is MoviesLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.horizontalPadding + 4,
                      vertical: r.h(8),
                    ),
                    child: Text(
                      "POPULAR MOVIES",
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: r.sp(12),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.horizontalPadding,
                    vertical: r.h(8),
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movie = state.movies[index];
                        return MovieCard(
                          movie: movie,
                          onTap: () => _openDetails(context, movie),
                          responsive: r,
                        );
                      },
                      childCount: state.movies.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: r.gridCrossAxisCount,
                      childAspectRatio: r.gridChildAspectRatio,
                      crossAxisSpacing: r.w(12),
                      mainAxisSpacing: r.h(16),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is MoviesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: AppTheme.primary, size: r.w(48)),
                  SizedBox(height: r.h(12)),
                  Text(
                    state.message,
                    style: TextStyle(
                        color: AppTheme.textMuted, fontSize: r.sp(14)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: r.h(20)),
                  TextButton(
                    onPressed: () {
                      context.read<MoviesCubit>().reset();
                      context.read<MoviesCubit>().fetchPopularMovies();
                    },
                    child: const Text('Retry',
                        style: TextStyle(color: AppTheme.primary)),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
