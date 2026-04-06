import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tetris_game.dart';
import '../widgets/game_grid.dart';
import '../widgets/control_buttons.dart';
import '../services/firebase_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late TetrisGame _game;
  late FirebaseService _firebaseService;
  int _currentHighScore = 0;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _loadSavedGame();
    _loadHighScore();
  }

  void _loadSavedGame() async {
    // Пытаемся загрузить сохраненную игру из Firebase
    var savedGame = await _firebaseService.loadGame();
    if (savedGame != null) {
      setState(() {
        _game = savedGame;
      });
    } else {
      setState(() {
        _game = TetrisGame.empty();
      });
    }
  }

  void _loadHighScore() async {
    int highScore = await _firebaseService.getGlobalHighScore();
    setState(() {
      _currentHighScore = highScore;
    });
  }

  void _moveLeft() {
    setState(() {
      // Логика движения влево
      if (_game.currentPiece['x'] > 0) {
        _game.currentPiece['x']--;
      }
    });
  }

  void _moveRight() {
    setState(() {
      if (_game.currentPiece['x'] < 9) {
        _game.currentPiece['x']++;
      }
    });
  }

  void _rotate() {
    setState(() {
      // Логика поворота
      _game.currentPiece['rotation'] = (_game.currentPiece['rotation'] + 1) % 4;
    });
  }

  void _fastDrop() {
    setState(() {
      // Логика быстрого падения
      while (_game.currentPiece['y'] < 19) {
        _game.currentPiece['y']++;
      }
      _lockPiece();
    });
  }

  void _lockPiece() {
    // Фиксируем фигуру на поле
    _game.grid[_game.currentPiece['y']][_game.currentPiece['x']] = 1;
    _game.score += 10;
    
    // Проверка Game Over
    if (_game.currentPiece['y'] == 0) {
      _gameOver();
    } else {
      // Создаем новую фигуру
      _game.currentPiece = {'x': 3, 'y': 0, 'shape': 'T', 'rotation': 0};
    }
  }

  void _gameOver() async {
    // Сохраняем рекорд
    await _firebaseService.saveScore(_game.score);
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameOverScreen(score: _game.score),
      ),
    );
  }

  void _pauseAndSave() async {
    setState(() {
      _game.isPaused = !_game.isPaused;
    });
    await _firebaseService.saveGame(_game);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Game saved to cloud!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Изменение цвета счета
    Color scoreColor = _game.score > _currentHighScore 
        ? Colors.amber 
        : Colors.white;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tetris Cloud'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Информационная панель
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('SCORE', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${_game.score}',
                      style: TextStyle(
                        color: scoreColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('HIGH SCORE', style: TextStyle(color: Colors.grey)),
                    Text(
                      '$_currentHighScore',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Игровое поле
          Expanded(
            child: GameGrid(
              grid: _game.grid,
              currentPiece: _game.currentPiece,
            ),
          ),
          
          // Кнопки управления
          ControlButtons(
            onLeft: _moveLeft,
            onRight: _moveRight,
            onRotate: _rotate,
            onDown: _fastDrop,
            onPause: _pauseAndSave,
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
