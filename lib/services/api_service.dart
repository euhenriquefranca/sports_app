import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sports_app/models/match_results_model.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<MatchResult>> fetchMatchResults(int page, int pageSize) async {
    final response = await http
        .get(Uri.parse('$baseUrl/MatchResults?page=$page&pageSize=$pageSize'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((item) => MatchResult.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load match results');
    }
  }

  Future<void> deleteMatchResult(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/MatchResults/$id'));
    if (response.statusCode != 204) {
      if (response.statusCode == 404) {
        final jsonResponse = json.decode(response.body);
        throw Exception(jsonResponse['title']);
      } else {
        throw Exception('Failed to delete match result');
      }
    }
  }

  Future<void> updateMatchResult(MatchResult matchResult) async {
    final response = await http.put(
      Uri.parse('$baseUrl/MatchResults/${matchResult.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(matchResult.toJson()),
    );
    if (response.statusCode != 204) {
      if (response.statusCode == 404) {
        final jsonResponse = json.decode(response.body);
        throw Exception(jsonResponse['title']);
      } else {
        throw Exception('Failed to update match result');
      }
    }
  }

  Future<MatchResult> createMatchResult(MatchResult matchResult) async {
    final response = await http.post(
      Uri.parse('$baseUrl/MatchResults/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(matchResult.toJson()),
    );
    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return MatchResult.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['title']);
    } else {
      throw Exception('Failed to create match result');
    }
  }
}
