import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    super.posterPath,
    required super.voteAverage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? 'Unknown',
        posterPath: json['poster_path'] as String?,
        voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      );
}

class MovieDetailsModel extends MovieDetailsEntity {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.overview,
    required super.genres,
    super.runtime,
    required super.releaseYear,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List<dynamic>? ?? [])
        .map((g) => (g as Map<String, dynamic>)['name'] as String)
        .toList();

    final releaseDate = json['release_date'] as String? ?? '';
    final releaseYear = releaseDate.isNotEmpty ? releaseDate.split('-').first : '';

    return MovieDetailsModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Unknown',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      overview: json['overview'] as String? ?? 'No overview available.',
      genres: genres,
      runtime: json['runtime'] as int?,
      releaseYear: releaseYear,
    );
  }
}
