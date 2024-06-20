import 'package:flutter/material.dart';
import 'package:sports_app/models/match_results_model.dart';
import '../services/api_service.dart';

class MatchResultFormScreen extends StatefulWidget {
  final MatchResult? matchResult;

  const MatchResultFormScreen({super.key, this.matchResult});

  @override
  _MatchResultFormScreenState createState() => _MatchResultFormScreenState();
}

class _MatchResultFormScreenState extends State<MatchResultFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _homeScore;
  late int _awayScore;
  late String _homeTeam;
  late String _awayTeam;
  late String _matchId;

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'https://sportapieniac.azurewebsites.net');
    if (widget.matchResult != null) {
      _homeScore = widget.matchResult!.homeScore;
      _awayScore = widget.matchResult!.awayScore;
      _homeTeam = widget.matchResult!.homeTeam;
      _awayTeam = widget.matchResult!.awayTeam;
      _matchId = widget.matchResult!.matchId;
    } else {
      _homeScore = 0;
      _awayScore = 0;
      _homeTeam = '';
      _awayTeam = '';
      _matchId = '';
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final matchResult = MatchResult(
        id: widget.matchResult?.id ?? 0,
        matchId: _matchId,
        homeTeam: _homeTeam,
        awayTeam: _awayTeam,
        homeScore: _homeScore,
        awayScore: _awayScore,
      );
      try {
        if (widget.matchResult == null) {
          await apiService.createMatchResult(matchResult);
          Navigator.pop(context, 'created');
        } else {
          await apiService.updateMatchResult(matchResult);
          Navigator.pop(context, 'updated');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save match result: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.matchResult == null ? 'Add Match Result' : 'Edit Match Result',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _homeTeam,
                decoration: const InputDecoration(labelText: 'Home Team'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the home team';
                  }
                  return null;
                },
                onSaved: (value) {
                  _homeTeam = value!;
                },
              ),
              TextFormField(
                initialValue: _awayTeam,
                decoration: const InputDecoration(labelText: 'Away Team'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the away team';
                  }
                  return null;
                },
                onSaved: (value) {
                  _awayTeam = value!;
                },
              ),
              TextFormField(
                initialValue: _homeScore.toString(),
                decoration: const InputDecoration(labelText: 'Home Score'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the home score';
                  }
                  return null;
                },
                onSaved: (value) {
                  _homeScore = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _awayScore.toString(),
                decoration: const InputDecoration(labelText: 'Away Score'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the away score';
                  }
                  return null;
                },
                onSaved: (value) {
                  _awayScore = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _matchId,
                decoration: const InputDecoration(labelText: 'Match ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the match ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _matchId = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
