import 'package:flutter/material.dart';

class GameGrid extends StatelessWidget {
  final List<List<int>> grid;
  final Map<String, dynamic> currentPiece;

  const GameGrid({
    Key? key,
    required this.grid,
    required this.currentPiece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Создаем копию сетки и накладываем текущую фигуру
    List<List<int>> displayGrid = List.generate(20, (i) => List.from(grid[i]));
    
    // Добавляем текущую фигуру (упрощенно для примера)
    if (currentPiece['y'] >= 0 && currentPiece['y'] < 20) {
      // Здесь логика отрисовки фигуры
      // Для простоты - закрашиваем одну клетку
      if (currentPiece['x'] >= 0 && currentPiece['x'] < 10) {
        displayGrid[currentPiece['y']][currentPiece['x']] = 1;
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        childAspectRatio: 1,
      ),
      itemCount: 200,
      itemBuilder: (context, index) {
        int row = index ~/ 10;
        int col = index % 10;
        bool isFilled = displayGrid[row][col] == 1;
        
        return Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: isFilled ? Colors.blue : Colors.grey[300],
            border: Border.all(color: Colors.grey.shade400),
          ),
        );
      },
    );
  }
}
