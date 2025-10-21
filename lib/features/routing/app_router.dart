import 'package:go_router/go_router.dart';
import 'package:interview/features/add%20video/presentation/add_video.dart';
import 'package:interview/features/auth/presentation/login_screen.dart';
import 'package:interview/features/home%20screen/presentation/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-feed',
        name: 'addFeed',
        builder: (context, state) => const AddFeedsScreen(),
      ),
    ],
  );
}
