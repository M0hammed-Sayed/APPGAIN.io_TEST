import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../data/datasources/movie_remote_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/movie_usecases.dart';
import '../cubits/details/details_cubit.dart';
import '../cubits/details/details_state.dart';

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

          if (state is DetailsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (state is DetailsLoaded) {
            return _DetailsContent(movie: state.movie, r: r);
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

  const _DetailsContent({
    super.key,
    required this.movie,
    required this.r,
  });

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
        SliverAppBar(
          expandedHeight: r.h(240),
          backgroundColor: AppTheme.background,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              margin: EdgeInsets.all(r.w(8)),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(r.w(10)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: r.sp(18),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: backdropUrl != null
                ? Image.network(
              backdropUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppTheme.surface),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(r.w(12)),
                      child: imageUrl != null
                          ? Image.network(
                        imageUrl,
                        width: posterW,
                        height: posterH,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: posterW,
                        height: posterH,
                        color: AppTheme.surfaceVariant,
                        child: const Icon(Icons.movie),
                      ),
                    ),
                    SizedBox(width: r.w(16)),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: r.sp(18),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: r.h(8)),
                          Text(
                            '${movie.voteAverage.toStringAsFixed(1)} / 10',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.h(25)),

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

                SizedBox(height: r.h(30)),

                // ✅ COPY LINK BUTTON
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final link = 'cinescope://details/${movie.id}';

                      Clipboard.setData(ClipboardData(text: link));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copied!'),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.w(24),
                        vertical: r.h(12),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary),
                        borderRadius: BorderRadius.circular(r.w(12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.link,
                            color: AppTheme.primary,
                            size: r.sp(18),
                          ),
                          SizedBox(width: r.w(8)),
                          Text(
                            'Copy Link',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: r.sp(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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
}