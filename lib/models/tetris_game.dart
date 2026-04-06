class TetrisGame {
  List<List<int>> grid;      // 10x20, 0=пусто, 1=занято
  Map<String, dynamic> currentPiece; // координаты падающей фигуры
  int score;
  int highScore;
  bool isPaused;

  TetrisGame({
    required this.grid,
    required this.currentPiece,
    required this.score,
    required this.highScore,
    required this.isPaused,
  });

  // Метод для JSON -> объект
  factory TetrisGame.fromJson(Map<String, dynamic> json) {
    return TetrisGame(
      grid: List<List<int>>.from(
        json['grid'].map((row) => List<int>.from(row))
      ),
      currentPiece: Map<String, dynamic>.from(json['currentPiece']),
      score: json['score'],
      highScore: json['highScore'] ?? 0,
      isPaused: json['isPaused'] ?? false,
    );
  }

  // Метод для объект -> JSON
  Map<String, dynamic> toJson() {
    return {
      'grid': grid,
      'currentPiece': currentPiece,
      'score': score,
      'highScore': highScore,
      'isPaused': isPaused,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Создание пустой игры
  static TetrisGame empty() {
    return TetrisGame(
      grid: List.generate(20, (_) => List.generate(10, (_) => 0)),
      currentPiece: {'x': 3, 'y': 0, 'shape': 'T', 'rotation': 0},
      score: 0,
      highScore: 0,
      isPaused: false,
    );
  }
}
