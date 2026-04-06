import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/game_screen.dart';
import 'screens/game_over_screen.dart';
import 'screens/leaderboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris Cloud',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const GameScreen(),
        '/game': (context) => const GameScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/gameover') {
          final score = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => GameOverScreen(score: score),
          );
        }
        return null;
      },
    );
  }
}
