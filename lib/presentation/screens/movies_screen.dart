import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/movie_entity.dart';
import '../cubits/movies/movies_cubit.dart';
import '../cubits/movies/movies_state.dart';
import '../widgets/movie_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoviesCubit>().fetchPopularMovies();
  }

  void _openDetails(BuildContext context, MovieEntity movie) {
    context.push('/movies/details/${movie.id}');
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
          // ✅ COPY PAGE LINK BUTTON
          IconButton(
            icon: const Icon(Icons.link, color: AppTheme.textSecondary),
            onPressed: () {
              const url = 'cinescope://movies_screen';

              Clipboard.setData(const ClipboardData(text: url));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Movies page link copied!'),
                ),
              );
            },
          ),

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
                SliverPadding(
                  padding: EdgeInsets.all(r.w(16)),
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
              child: Text(state.message),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}