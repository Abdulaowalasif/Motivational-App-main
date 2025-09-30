import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/constant/string_constent/icon_string.dart';
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';
import 'package:motivational_app/routes/routes_name.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constant/local_data/store_variable.dart';
import '../../core/utills/local_storage/user_info.dart';

class Motivation1 extends StatefulWidget {
  const Motivation1({super.key});

  @override
  State<Motivation1> createState() => _Motivation1State();
}

class _Motivation1State extends State<Motivation1> {
  Map<String, dynamic> userProfile = {};
  String motivation = '';
  bool isLoading = true;
  String? error;
  String motivationID = '';
  Color reactionColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _getMotivationProfileSetup();
  }

  void _getMotivationProfileSetup() async {
    String? accessToken = await UserInfo.getUserAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        final response = await http.get(
            Uri.parse(ApiEndpoint.motivationProfile),
            headers: {
              'Authorization': 'Bearer $accessToken',
            }
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final profile = data['profile'];

          setState(() {
            // Fixed the mapping - values were incorrectly assigned
            userProfile['age'] = profile['age_range'];
            userProfile['name'] = profile['name'];
            userProfile['gender'] = profile['gender'];
            userProfile['language'] = profile['language'];
            userProfile['mission'] = profile['mission'];
            userProfile['tone'] = profile['tone'];
            userProfile['grind_level'] = profile['grind_level'];
          });

          await _getMotivation();
        } else {
          setState(() {
            error = 'Failed to fetch profile. Status: ${response.statusCode}';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          error = 'Error fetching motivation profile setup: $e';
          isLoading = false;
        });
      }
    } else {
      Get.toNamed(RouteName.signin);
    }
  }

  void _giveReaction(String reactionID)async{
    String? accessToken = await UserInfo.getUserAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        final response = await http.post(
            Uri.parse(ApiEndpoint.giveReaction),
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
            body: {
              "motivation_message": reactionID,
              "reaction_type": "love",
            }
        );

        print('Response status for give reaction: ${response.statusCode} and body: ${response.body}');

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Handle successful reaction
          print('Reaction given successfully');
          setState(() {
            reactionColor = Colors.red; // Change color to indicate reaction
          });
        } else {
          SnackbarHelper.error(
            'Failed to give reaction. Only premium users can give reactions.',
            context
          );
          print('Failed to give reaction. Status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error giving reaction: $e');
      }
    } else {
      Get.toNamed(RouteName.signin);
    }

  }

  Future<void> _getMotivation() async {
    String? accessToken = await UserInfo.getUserAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        final response = await http.post(
            Uri.parse(ApiEndpoint.motivation),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "age": userProfile['age'] ?? "25 to 34",
              "name": userProfile['name'] ?? "John",
              "gender": userProfile['gender'] ?? "Male",
              "language": userProfile['language'] ?? "English (US)",
              "mission": userProfile['mission'] ?? "Dominate my discipline",
              "tone": userProfile['tone'] ?? "Hardcore",
              "grind_level": userProfile['grind_level'] ?? "In the trenches"
            })
        );
        
        



        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final motivationText = data['motivation'];

          setState(() {
            motivation = motivationText ?? '';
            motivationID = data['motivation_id'].toString();
            isLoading = false;
            error = null;
          });
        } else {
          setState(() {
            error = 'Failed to get motivation. Status: ${response.statusCode}';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          error = 'Error fetching motivation: $e';
          isLoading = false;
        });
      }
    } else {
      Get.toNamed(RouteName.signin);
    }
  }

  Future<void> _refreshMotivation() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    await _getMotivation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Image.asset(IconString.menuIcon),
          ),
        ),
        // title: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Image.asset(IconString.heartIcon, width: 20, height: 20, color: Colors.white),
        //     const SizedBox(width: 10),
        //     const Text('1/5', style: TextStyle(color: Colors.white, fontSize: 16)),
        //     const SizedBox(width: 10),
        //     SizedBox(
        //       width: 150,
        //       child: LinearProgressIndicator(
        //         minHeight: 8,
        //         value: 0.2,
        //         color: Colors.white,
        //         backgroundColor: Colors.grey,
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //   ],
        // ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                child: Text(
                  'Inspire & Thrive', // More meaningful app title
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined, color: Colors.white, size: 20), // More personal icon
              title: const Text('Set Motivational profile', style: TextStyle(color: Colors.white)), // Better text for changing info
              onTap: () {
                Get.toNamed(RouteName.nameScreen);
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.notifications_active, color: Colors.white, size: 20), // Clearer icon for reminders
            //   title: const Text('Daily Reminders', style: TextStyle(color: Colors.white)), // Concise and clear text
            //   onTap: () {
            //     Get.toNamed(RouteName.quoteSchedule);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.workspace_premium, color: Colors.white, size: 20), // Icon to signify a premium feature
              title: const Text('Unlock Premium', style: TextStyle(color: Colors.white)), // More appealing text
              onTap: () {
                Get.toNamed(RouteName.subscription, arguments: {
                  'daysRemaining': StoreVariable.remainingDays,
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: _buildMotivationContent(),
              ),
            ),
            const Spacer(),
            isLoading? const SizedBox.shrink() : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _giveReaction(motivationID);
                  },
                  child: Image.asset(
                    IconString.heartIcon,
                    width: 35,
                    color: reactionColor,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Add share logic here
                    if (motivation.isNotEmpty) {

                      SharePlus.instance.share(
                          ShareParams(text: motivation, subject: 'Motivation from Motivational App')
                      );
                    }
                  },
                  child: Image.asset(
                    IconString.shareIcon,
                    width: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ) ,
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.history);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF454444),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        IconString.clockIcon,
                        width: 20,
                        color: Colors.white,
                      )
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.publicLeaderboard);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF454444),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            IconString.leaderboardIcon,
                            width: 20,
                            color: Colors.white,
                          )
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.profile);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF454444),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            IconString.userIcon,
                            width: 20,
                            color: Colors.white,
                          )
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationContent() {
    if (isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
          SizedBox(height: 20),
          Text(
            'Loading your motivation...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 20),
          Text(
            'Something went wrong',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            error!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshMotivation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF454444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      );
    }

    return Text(
      motivation.isNotEmpty ? motivation : 'No motivation available',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}