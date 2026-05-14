import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/notification_service.dart';
import 'package:moves_test/router/App_Router.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/movie_remote_datasource.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/usecases/movie_usecases.dart';
import 'presentation/cubits/movies/movies_cubit.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print(' Background notification: ${message.notification?.title}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService.init();
  runApp(const CineScopeApp());
}

class CineScopeApp extends StatelessWidget {
  const CineScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = MovieRemoteDataSource();
    final repository = MovieRepositoryImpl(remoteDataSource);
    final getPopularMovies = GetPopularMoviesUseCase(repository);

    return BlocProvider(
      create: (_) => MoviesCubit(getPopularMovies),
      child: MaterialApp.router(
        title: 'CineScope',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}