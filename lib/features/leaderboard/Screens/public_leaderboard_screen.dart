import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/core/constant/string_constent/icon_string.dart';
import 'package:motivational_app/routes/routes_name.dart';

import '../../../core/constant/string_constent/badges_path_string.dart';
import '../controllers/get_public_leaderboard.dart';

class PublicLeaderboardScreen extends StatefulWidget {
  const PublicLeaderboardScreen({super.key});

  @override
  State<PublicLeaderboardScreen> createState() => _PublicLeaderboardScreenState();
}

class _PublicLeaderboardScreenState extends State<PublicLeaderboardScreen> {

  List<Map<String, dynamic>> leaderboardData = [];
  Map<String, dynamic> userStats = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  void fetchLeaderboardData() {
    GetPublicLeaderboard getPublicLeaderboard = GetPublicLeaderboard();
    getPublicLeaderboard.fetchLeaderboard().then((data) {
      setState(() {
        // Extract leaderboard array from the response
        leaderboardData = List<Map<String, dynamic>>.from(data['leaderboard'] ?? []);
        userStats = data['user_stats'] ?? {};
        isLoading = false;
      });
    }).catchError((error) {
      print('Error fetching leaderboard: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget buildTopThreeWinners() {
    if (leaderboardData.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text('No leaderboard data available'),
        ),
      );
    }



    // Get top 3 participants (or less if not available)
    Map<String, dynamic>? first = leaderboardData.length > 0 ? leaderboardData[0] : null;
    Map<String, dynamic>? second = leaderboardData.length > 1 ? leaderboardData[1] : null;
    Map<String, dynamic>? third = leaderboardData.length > 2 ? leaderboardData[2] : null;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Third place (left side with top margin)
          buildWinnerCard(
            participant: third,
            position: 3,
            radius: 35,
            badgeRadius: 14,
            fontSize: 14,
            pointsFontSize: 12,
            iconSize: 14,
            topMargin: 60,
            backgroundColor: Colors.orange,
            borderColor: Colors.orange,
          ),

          // First place (center - highest position)
          buildWinnerCard(
            participant: first,
            position: 1,
            radius: 45,
            badgeRadius: 18,
            fontSize: 18,
            pointsFontSize: 16,
            iconSize: 18,
            topMargin: 0,
            backgroundColor: Colors.green,
            borderColor: Colors.green,
            showCrown: true,
          ),

          // Second place (right side with top margin)
          buildWinnerCard(
            participant: second,
            position: 2,
            radius: 38,
            badgeRadius: 15,
            fontSize: 15,
            pointsFontSize: 13,
            iconSize: 15,
            topMargin: 40,
            backgroundColor: Colors.grey[600]!,
            borderColor: Colors.grey[600]!,
          ),
        ],
      ),
    );
  }

  Widget buildWinnerCard({
    required Map<String, dynamic>? participant,
    required int position,
    required double radius,
    required double badgeRadius,
    required double fontSize,
    required double pointsFontSize,
    required double iconSize,
    required double topMargin,
    required Color backgroundColor,
    required Color borderColor,
    bool showCrown = false,
  }) {
    if (participant == null) {
      return Container(
        margin: EdgeInsets.only(top: topMargin),
        child: Column(
          children: [
            if (showCrown) ...[
              SizedBox(height: 45), // Space for crown
            ],
            CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: radius, color: Colors.grey[600]),
            ),
            SizedBox(height: 15),
            Text('No Data', style: TextStyle(fontSize: fontSize)),
          ],
        ),
      );
    }

    String imageUrl = participant['picture'] ?? '';
    String name = participant['name'] ?? 'Unknown';
    int points = participant['total_points'] ?? 0;

    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showCrown) ...[
            Image.asset(
              IconString.kingIcon,
              width: 40,
              height: 40,
            ),
            const SizedBox(height: 5),
          ],
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: radius,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                backgroundColor: Colors.grey[300],
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: radius, color: Colors.grey[600])
                    : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 3),
                  ),
                ),
              ),
              Positioned(
                bottom: -12,
                child: CircleAvatar(
                  radius: badgeRadius,
                  backgroundColor: backgroundColor,
                  child: Text(
                    '$position',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: badgeRadius - 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            name,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$points Points',
                style: TextStyle(fontSize: pointsFontSize, color: Colors.grey),
              ),
              SizedBox(width: iconSize/2),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: iconSize,
              )
            ],
          )
        ],
      ),
    );
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
      case 'Alpha':
        return BadgesPathString.alphaWolf;
      default:
        return 'https://via.placeholder.com/40/FFFFFF/000000?text=Badge';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Leaderboard', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              IconString.crossBtn,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Top 3 winners section
          buildTopThreeWinners(),

          const SizedBox(height: 20),

          // Full leaderboard list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: leaderboardData.length,
                        itemBuilder: (context, index) {
                          final data = leaderboardData[index];
                          final isHighlighted = data['highlight'] ?? false;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: isHighlighted ? Colors.blue[50] : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: isHighlighted
                                  ? Border.all(color: Colors.blue, width: 2)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Position
                                Container(
                                  width: 30,
                                  child: Text(
                                    '${data['position']}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isHighlighted ? Colors.blue : Colors.black
                                    ),
                                  ),
                                ),

                                // Profile image
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: data['picture'] != null
                                        ? NetworkImage(data['picture'])
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    child: data['picture'] == null
                                        ? Icon(Icons.person, color: Colors.grey[600])
                                        : null,
                                  ),
                                ),

                                // Name and details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isHighlighted ? Colors.blue : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      if (data['badges'] != null)
                                        Text(
                                          '${data['badges']['name']} (Level ${data['badges']['level']})',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600]
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // Badge icon
                                // Container(
                                //   width: 40,
                                //   height: 40,
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     color: Colors.amber,
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.grey.withOpacity(0.3),
                                //         spreadRadius: 1,
                                //         blurRadius: 3,
                                //       ),
                                //     ],
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       '${data['badge']?['level'] ?? '?'}',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Material(
                                      elevation: 4,
                                      shape: CircleBorder(),
                                      child: Image.asset(
                                        getBadgeImageUrl(data['badge']?['name'] ?? 'Unknown'),
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 15),

                                // Points
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${data['total_points']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isHighlighted ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'points',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Self leaderboard button
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.selfLeaderboard);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              IconString.selfLeaderboardIcon,
                              width: 40,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'View My Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}