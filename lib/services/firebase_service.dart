import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tetris_game.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _gameId = 'current_game'; // Фиксированный ID для сохранения
  final String _scoresCollection = 'scores';

  // Сохранение игры в облако
  Future<void> saveGame(TetrisGame game) async {
    try {
      await _firestore.collection('saved_games').doc(_gameId).set(game.toJson());
      print('Game saved successfully');
    } catch (e) {
      print('Error saving game: $e');
    }
  }

  // Загрузка игры из облака
  Future<TetrisGame?> loadGame() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('saved_games').doc(_gameId).get();
      
      if (doc.exists) {
        return TetrisGame.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error loading game: $e');
    }
    return null;
  }

  // Сохранение рекорда после Game Over
  Future<void> saveScore(int score) async {
    try {
      await _firestore.collection(_scoresCollection).add({
        'score': score,
        'date': DateTime.now(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Score saved: $score');
    } catch (e) {
      print('Error saving score: $e');
    }
  }

  // Получение глобального рекорда
  Future<int> getGlobalHighScore() async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_scoresCollection)
          .orderBy('score', descending: true)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        return query.docs.first['score'] as int;
      }
    } catch (e) {
      print('Error getting high score: $e');
    }
    return 0;
  }

  // Живая таблица лидеров (Stream)
  Stream<List<Map<String, dynamic>>> getLeaderboardStream() {
    return _firestore
        .collection(_scoresCollection)
        .orderBy('score', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {
              'id': doc.id,
              'score': doc['score'],
              'date': doc['date'],
            };
          }).toList();
        });
  }
}
