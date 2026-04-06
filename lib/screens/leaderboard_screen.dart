import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class LeaderboardScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard - Top 10'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getLeaderboardStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          
          var scores = snapshot.data!;
          
          if (scores.isEmpty) {
            return const Center(child: Text('No scores yet!'));
          }
          
          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              var score = scores[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                    backgroundColor: index == 0 ? Colors.amber : Colors.grey,
                  ),
                  title: Text('Score: ${score['score']}'),
                  subtitle: Text('Date: ${score['date']?.toLocal() ?? 'Unknown'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
