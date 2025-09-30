import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:motivational_app/core/utills/local_storage/user_info.dart';

import '../../../core/constant/api_endpoin.dart';

class GetPublicLeaderboard {
  Future<Map<String, dynamic>> fetchLeaderboard() async {
    String? accessToken = await UserInfo.getUserAccessToken();
    if (accessToken != null) {
      try {
        final response = await http.get(
            Uri.parse(ApiEndpoint.leaderboard),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            }
        );

        print('Status Code for geting leaderboard: ${response.statusCode} - Response: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Check if the response is a Map (object) as expected
          if (data is Map<String, dynamic>) {
            return data;
          } else {
            throw Exception('Unexpected response format: Expected object but got ${data.runtimeType}');
          }
        } else {
          // Handle different error status codes
          final errorData = jsonDecode(response.body);
          throw Exception('Failed to fetch leaderboard: ${response.statusCode} - ${errorData['message'] ?? 'Unknown error'}');
        }
      } catch (e) {
        print('Error in fetchLeaderboard: $e');
        // Return empty structure that matches expected format
        return {
          'count': 0,
          'next': null,
          'previous': null,
          'leaderboard': [],
          'user_stats': {},
          'total_participants': 0,
        };
      }
    } else {
      throw Exception('Access token not available');
    }
  }

  // Optional: Add a method to get only the leaderboard array if needed elsewhere
  Future<List<Map<String, dynamic>>> fetchLeaderboardList() async {
    final data = await fetchLeaderboard();
    return List<Map<String, dynamic>>.from(data['leaderboard'] ?? []);
  }

  // Optional: Add a method to get user stats
  Future<Map<String, dynamic>> fetchUserStats() async {
    final data = await fetchLeaderboard();
    return Map<String, dynamic>.from(data['user_stats'] ?? {});
  }
}