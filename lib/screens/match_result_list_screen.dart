import 'package:flutter/material.dart';
import 'package:sports_app/models/match_results_model.dart';
import '../services/api_service.dart';
import 'match_result_form_screen.dart';

class MatchResultListScreen extends StatefulWidget {
  const MatchResultListScreen({super.key});

  @override
  _MatchResultListScreenState createState() => _MatchResultListScreenState();
}

class _MatchResultListScreenState extends State<MatchResultListScreen> {
  late ApiService apiService;
  late Future<List<MatchResult>> futureMatchResults;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'https://sportapieniac.azurewebsites.net');
    futureMatchResults = apiService.fetchMatchResults(1, 10);
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Results'),
      ),
      body: FutureBuilder<List<MatchResult>>(
        future: futureMatchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No match results found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final matchResult = snapshot.data![index];
                return ListTile(
                  title: Text(
                      '${matchResult.homeTeam} vs ${matchResult.awayTeam}'),
                  subtitle: Text(
                      'Score: ${matchResult.homeScore} - ${matchResult.awayScore}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MatchResultFormScreen(
                                  matchResult: matchResult),
                            ),
                          );
                          if (result == 'updated') {
                            setState(() {
                              futureMatchResults =
                                  apiService.fetchMatchResults(1, 10);
                            });
                            _showSnackBar('Match result updated successfully',
                                backgroundColor: Colors.green);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await apiService.deleteMatchResult(matchResult.id);
                            setState(() {
                              futureMatchResults =
                                  apiService.fetchMatchResults(1, 10);
                            });
                            _showSnackBar('Match result deleted successfully',
                                backgroundColor: Colors.green);
                          } catch (e) {
                            _showSnackBar(e.toString());
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MatchResultFormScreen(),
            ),
          );
          if (result == 'created') {
            setState(() {
              futureMatchResults = apiService.fetchMatchResults(1, 10);
            });
            _showSnackBar('Match result created successfully',
                backgroundColor: Colors.green);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
