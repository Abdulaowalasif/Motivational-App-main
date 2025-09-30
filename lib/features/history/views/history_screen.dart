import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/routes/routes_name.dart';
import '../../../core/utills/local_storage/user_info.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MotivationHistory> historyMotivations = [];
  bool isLoading = true;
  String? error;
  int currentPage = 1;
  bool hasNextPage = false;
  bool isLoadingMore = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchHistoryMotivations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (hasNextPage && !isLoadingMore) {
        _loadMoreMotivations();
      }
    }
  }

  Future<void> _fetchHistoryMotivations({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        currentPage = 1;
        historyMotivations.clear();
        isLoading = true;
        error = null;
      });
    }

    String? accessToken = await UserInfo.getUserAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      Get.toNamed(RouteName.signin);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoint.motivationHistory), // Adjust endpoint as needed
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        List<MotivationHistory> newMotivations = results.map((item) =>
            MotivationHistory.fromJson(item)
        ).toList();

        setState(() {
          if (isRefresh) {
            historyMotivations = newMotivations;
          } else {
            historyMotivations.addAll(newMotivations);
          }
          hasNextPage = data['next'] != null;
          isLoading = false;
          isLoadingMore = false;
          error = null;
        });
      } else if (response.statusCode == 401) {
        Get.toNamed(RouteName.signin);
      } else {
        setState(() {
          error = 'Failed to load history. Status: ${response.statusCode}';
          isLoading = false;
          isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching motivation history: $e';
        isLoading = false;
        isLoadingMore = false;
      });
      print('Error fetching motivation history: $e');
    }
  }

  Future<void> _loadMoreMotivations() async {
    if (isLoadingMore || !hasNextPage) return;

    setState(() {
      isLoadingMore = true;
    });

    currentPage++;
    await _fetchHistoryMotivations();
  }

  Future<void> _refreshHistory() async {
    await _fetchHistoryMotivations(isRefresh: true);
  }

  String _formatDate(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  Color _getReactionColor(UserReaction? reaction) {
    if (reaction == null) return Colors.grey;

    switch (reaction.reactionType) {
      case 'like':
        return Colors.blue;
      case 'love':
        return Colors.red;
      case 'dislike':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getReactionIcon(UserReaction? reaction) {
    if (reaction == null) return Icons.favorite_border;

    switch (reaction.reactionType) {
      case 'like':
        return Icons.thumb_up;
      case 'love':
        return Icons.favorite;
      case 'dislike':
        return Icons.thumb_down;
      default:
        return Icons.favorite_border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        actions: [
          if (!isLoading)
            IconButton(
              onPressed: _refreshHistory,
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading && historyMotivations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading your motivation history...'),
          ],
        ),
      );
    }

    if (error != null && historyMotivations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshHistory,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (historyMotivations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No motivation history yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your motivational messages will appear here',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshHistory,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: historyMotivations.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == historyMotivations.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final motivation = historyMotivations[index];
          final reactionColor = _getReactionColor(motivation.userReaction);
          final hasReaction = motivation.userReaction != null;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: hasReaction ? reactionColor : Colors.grey.shade300,
                width: hasReaction ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getReactionIcon(motivation.userReaction),
                      color: reactionColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    if (hasReaction)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: reactionColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${motivation.userReaction!.reactionDisplay} (+${motivation.userReaction!.pointsEarned})',
                          style: TextStyle(
                            fontSize: 10,
                            color: reactionColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Text(
                      _formatDate(motivation.generatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!motivation.viewed)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  motivation.message,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserReaction {
  final String reactionType;
  final String reactionDisplay;
  final int pointsEarned;
  final String createdAt;

  UserReaction({
    required this.reactionType,
    required this.reactionDisplay,
    required this.pointsEarned,
    required this.createdAt,
  });

  factory UserReaction.fromJson(Map<String, dynamic> json) {
    return UserReaction(
      reactionType: json['reaction_type'] ?? '',
      reactionDisplay: json['reaction_display'] ?? '',
      pointsEarned: json['points_earned'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class MotivationHistory {
  final int id;
  final String message;
  final String generatedAt;
  final UserReaction? userReaction;
  final bool viewed;

  MotivationHistory({
    required this.id,
    required this.message,
    required this.generatedAt,
    this.userReaction,
    required this.viewed,
  });

  factory MotivationHistory.fromJson(Map<String, dynamic> json) {
    return MotivationHistory(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      generatedAt: json['generated_at'] ?? '',
      userReaction: json['user_reaction'] != null
          ? UserReaction.fromJson(json['user_reaction'])
          : null,
      viewed: json['viewed'] ?? false,
    );
  }
}