import 'package:flutter/material.dart';
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/constant/string_constent/badges_path_string.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/utills/local_storage/user_info.dart';

class SelfLeaderboard extends StatefulWidget {
  const SelfLeaderboard({super.key});

  @override
  State<SelfLeaderboard> createState() => _SelfLeaderboardState();
}

class _SelfLeaderboardState extends State<SelfLeaderboard> {
  final List<Map<String, dynamic>> levels = [
    {"rank": 10, "title": "Lone Wolf", "minPoints": 0, "maxPoints": 49},
    {"rank": 9, "title": "Tracker", "minPoints": 50, "maxPoints": 99},
    {"rank": 8, "title": "Hunter", "minPoints": 100, "maxPoints": 149},
    {"rank": 7, "title": "Stalker", "minPoints": 150, "maxPoints": 199},
    {"rank": 6, "title": "Howler", "minPoints": 200, "maxPoints": 299},
    {"rank": 5, "title": "Pack Wolf", "minPoints": 300, "maxPoints": 399},
    {"rank": 4, "title": "Enforcer", "minPoints": 400, "maxPoints": 499},
    {"rank": 3, "title": "Shadow Alpha", "minPoints": 500, "maxPoints": 599},
    {"rank": 2, "title": "Titan Alpha", "minPoints": 600, "maxPoints": 799},
    {"rank": 1, "title": "Alpha Wolf", "minPoints": 800, "maxPoints": 1000},
  ];

  Map<String, dynamic>? userPoints;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    getUserPoints();
  }

  Future<void> getUserPoints() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      String? accessToken = await UserInfo.getUserAccessToken();

      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse(ApiEndpoint.userPoints),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            userPoints = data['points'];
            isLoading = false;
          });
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load user points: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  String getBadgeImageUrl(String badgeName) {
    switch (badgeName) {
      case 'Lone Wolf':
        return BadgesPathString.loneWolf;
      case 'Tracker':
        return BadgesPathString.tracker;
      case 'Hunter':
        return BadgesPathString.hunter;
      case 'Stalker':
        return BadgesPathString.staiker;
      case 'Howler':
        return BadgesPathString.howler;
      case 'Pack Wolf':
        return BadgesPathString.packWolf;
      case 'Enforcer':
        return BadgesPathString.enforcer;
      case 'Shadow Alpha':
        return BadgesPathString.shadowAlpha;
      case 'Titan Alpha':
        return BadgesPathString.titanAlpha;
      case 'Alpha Wolf':
        return BadgesPathString.alphaWolf;
      default:
        return BadgesPathString.loneWolf; // Default fallback
    }
  }

  double calculateProgress(Map<String, dynamic> level) {
    if (userPoints == null) return 0.0;

    final currentPoints = userPoints!['total_points'] ?? 0;
    final minPoints = level['minPoints'];
    final maxPoints = level['maxPoints'];

    if (currentPoints < minPoints) return 0.0;
    if (currentPoints >= maxPoints) return 1.0;

    return (currentPoints - minPoints) / (maxPoints - minPoints);
  }

  bool isCurrentLevel(Map<String, dynamic> level) {
    if (userPoints == null || userPoints!['badge'] == null) return false;
    return level['title'] == userPoints!['badge']['name'];
  }

  Widget buildLevelCard(Map<String, dynamic> level, int index) {
    final progress = calculateProgress(level);
    final isCurrent = isCurrentLevel(level);
    final currentPoints = userPoints?['total_points'] ?? 0;
    final isUnlocked = currentPoints >= level['minPoints'];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: isCurrent ? 8 : 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isCurrent ? Colors.blue.shade50 : null,
      child: Container(
        decoration: isCurrent
            ? BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Rank + Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent ? Colors.blue : const Color(0xFF3B4043),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: isCurrent
                          ? Colors.blue
                          : const Color(0xFF1A0F24),
                      radius: 16,
                      child: Text(
                        level["rank"].toString(),
                        style: TextStyle(
                          color: isCurrent
                              ? Colors.white
                              : const Color(0xFFFFDD64),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              level["title"],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: isCurrent ? Colors.blue : null,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Current',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          "Rank ${level["rank"]} • ${level["minPoints"]}-${level["maxPoints"]} points",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isCurrent && userPoints != null) ...[
                          Text(
                            "Current: ${userPoints!['total_points']} points",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Progress bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    // Current level badge (circular)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUnlocked ? Colors.white : Colors.grey.shade300,
                        border: Border.all(
                          color: isCurrent ? Colors.blue : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          getBadgeImageUrl(level["title"]),
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          color: isUnlocked ? null : Colors.grey,
                          colorBlendMode: isUnlocked ? null : BlendMode.saturation,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 16,
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCurrent ? Colors.blue : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // Next level badge preview (circular)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          index < levels.length - 1 ? getBadgeImageUrl(levels[index + 1]["title"]) : getBadgeImageUrl("Alpha Wolf"),
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          color: Colors.grey.shade600,
                          colorBlendMode: BlendMode.saturation,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getUserPoints,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getUserPoints,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // User stats header
          if (userPoints != null) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${userPoints!['total_points']} Points',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatChip('Daily Login', userPoints!['daily_login_points']),
                      _buildStatChip('Motivation', userPoints!['motivation_view_points']),
                      _buildStatChip('Reactions', userPoints!['reaction_points']),
                    ],
                  ),
                  if (userPoints!['badge'] != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Next: ${userPoints!['badge']['next_badge_name']} (${userPoints!['badge']['points_to_next_badge']} points to go)',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Levels list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                return buildLevelCard(levels[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}