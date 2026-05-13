import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/movie_entity.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;
  final Responsive responsive;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final r = responsive;
    final imageUrl = movie.posterPath != null
        ? '${AppConstants.imageBaseUrl}${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(r.w(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(r.w(16)),
                ),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => _placeholder(r),
                      )
                    : _placeholder(r),
              ),
            ),
            // Info
            Padding(
              padding: EdgeInsets.all(r.w(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: r.sp(13),
                    ),
                  ),
                  SizedBox(height: r.h(6)),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: AppTheme.gold, size: r.sp(14)),
                      SizedBox(width: r.w(4)),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: r.sp(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(Responsive r) => Container(
        color: AppTheme.surfaceVariant,
        child: Center(
          child:
              Icon(Icons.movie, color: Colors.white24, size: r.sp(40)),
        ),
      );
}
