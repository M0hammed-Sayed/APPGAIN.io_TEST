import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../data/datasources/movie_remote_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/movie_usecases.dart';
import '../cubits/details/details_cubit.dart';
import '../cubits/details/details_state.dart';

/// Creates its own [DetailsCubit] so the movies list state is never touched.
class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailsCubit(
        GetMovieDetailsUseCase(
          MovieRepositoryImpl(MovieRemoteDataSource()),
        ),
      )..fetchDetails(movieId),
      child: _DetailsView(movieId: movieId),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final int movieId;
  const _DetailsView({required this.movieId});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          if (state is DetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          }

          if (state is DetailsLoaded) {
            return _DetailsContent(movie: state.movie, r: r);
          }

          if (state is DetailsError) {
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

class _DetailsContent extends StatelessWidget {
  final MovieDetailsEntity movie;
  final Responsive r;

  const _DetailsContent({required this.movie, required this.r});

  @override
  Widget build(BuildContext context) {
    final backdropUrl = movie.backdropPath != null
        ? '${AppConstants.backdropBaseUrl}${movie.backdropPath}'
        : null;
    final imageUrl = movie.posterPath != null
        ? '${AppConstants.imageBaseUrl}${movie.posterPath}'
        : null;

    final posterW = r.isTablet ? r.w(140) : r.w(110);
    final posterH = posterW * 1.5;

    return CustomScrollView(
      slivers: [
        // Backdrop + back
        SliverAppBar(
          expandedHeight: r.h(240),
          backgroundColor: AppTheme.background,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.all(r.w(8)),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(r.w(10)),
              ),
              child: Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: r.sp(18)),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: backdropUrl != null
                ? ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppTheme.background],
                    ).createShader(rect),
                    blendMode: BlendMode.darken,
                    child: Image.network(
                      backdropUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppTheme.surface),
                    ),
                  )
                : Container(color: AppTheme.surface),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: r.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster
                    ClipRRect(
                      borderRadius: BorderRadius.circular(r.w(12)),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              width: posterW,
                              height: posterH,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _posterPlaceholder(r, posterW, posterH),
                            )
                          : _posterPlaceholder(r, posterW, posterH),
                    ),
                    SizedBox(width: r.w(16)),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: r.h(8)),
                          Text(
                            movie.title,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: r.sp(18),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: r.h(8)),
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  color: AppTheme.gold, size: r.sp(18)),
                              SizedBox(width: r.w(4)),
                              Text(
                                '${movie.voteAverage.toStringAsFixed(1)} / 10',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: r.sp(14),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.h(8)),
                          Wrap(
                            spacing: r.w(8),
                            runSpacing: r.h(6),
                            children: [
                              if (movie.releaseYear.isNotEmpty)
                                _chip(r, movie.releaseYear),
                              if (movie.runtime != null)
                                _chip(r, '${movie.runtime}m'),
                            ],
                          ),
                          SizedBox(height: r.h(10)),
                          Wrap(
                            spacing: r.w(6),
                            runSpacing: r.h(6),
                            children:
                                movie.genres.map((g) => _genreChip(r, g)).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.h(28)),

                Text(
                  'OVERVIEW',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: r.sp(12),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: r.h(10)),
                Text(
                  movie.overview,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: r.sp(14.5),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: r.h(40)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(Responsive r, String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: r.w(10), vertical: r.h(4)),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(r.w(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: AppTheme.textSecondary, fontSize: r.sp(12)),
        ),
      );

  Widget _genreChip(Responsive r, String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: r.w(10), vertical: r.h(4)),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primary.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(r.w(20)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: r.sp(11),
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Widget _posterPlaceholder(Responsive r, double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(r.w(12)),
        ),
        child: Icon(Icons.movie, color: Colors.white24, size: r.sp(40)),
      );
}
