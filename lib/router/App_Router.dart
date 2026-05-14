
import 'dart:developer';

import 'package:go_router/go_router.dart';
import '../presentation/screens/movie_details_screen.dart';
import '../presentation/screens/movies_screen.dart';
import '../presentation/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
String normalizeIncomingUri(Uri uri) {
  final segments = <String>[];
  if (uri.host.isNotEmpty) segments.add(uri.host);
  segments.addAll(uri.pathSegments.where((s) => s.isNotEmpty));
  final path = '/${segments.join('/')}';
  return Uri(
    path: path,
    queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
  ).toString();
}

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  redirect: (context, state) {
    if (kDebugMode) {
      log(' Deep link opened: ${state.uri}');
    }

    final normalizedPath = normalizeIncomingUri(state.uri);
    if (normalizedPath != state.uri.toString()) return normalizedPath;
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/movies',                          // ← deep link: yourapp://movies
      builder: (context, state) => const MoviesScreen(),
    ),
    GoRoute(
      path: '/movies/details/:id',              // ← deep link: yourapp://movies/details/123
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MovieDetailsScreen(movieId: int.parse(id));
      },
    ),
  ],
);