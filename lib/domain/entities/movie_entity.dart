class MovieEntity {
  final int id;
  final String title;
  final String? posterPath;
  final double voteAverage;

  const MovieEntity({
    required this.id,
    required this.title,
    this.posterPath,
    required this.voteAverage,
  });
}

class MovieDetailsEntity {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String overview;
  final List<String> genres;
  final int? runtime;
  final String releaseYear;

  const MovieDetailsEntity({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.genres,
    this.runtime,
    required this.releaseYear,
  });
}
