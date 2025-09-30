import 'package:get/get.dart';
import 'package:motivational_app/features/history/views/history_screen.dart';
import 'package:motivational_app/features/leaderboard/Screens/public_leaderboard_screen.dart';
import 'package:motivational_app/features/leaderboard/Screens/self_leaderboard.dart';

import 'package:motivational_app/features/profile_setup/AgeScreen.dart';
import 'package:motivational_app/features/home/daily_routines.dart';
import 'package:motivational_app/features/profile_setup/gender.dart';
import 'package:motivational_app/features/profile_setup/grind_level.dart';
import 'package:motivational_app/features/profile_setup/language_selection.dart';
import 'package:motivational_app/features/home/motivation.dart';
import 'package:motivational_app/features/profile_setup/name_screen.dart';
import 'package:motivational_app/features/profile_setup/question_1.dart';
import 'package:motivational_app/features/home/quote_schedule.dart';
import 'package:motivational_app/features/subscription/subscription.dart';
import 'package:motivational_app/features/home/unlock_alpha.dart';
import 'package:motivational_app/features/profile_setup/upsell_to_premium.dart';


import '../features/auth/views/account_created_successfully.dart';
import '../features/auth/views/forgot_password.dart';
import '../features/auth/views/reset_password.dart';
import '../features/auth/views/sign_in_screen.dart';
import '../features/auth/views/sign_up_screen.dart';
import '../features/auth/views/verify_code.dart';

import '../features/home/motivation1.dart';
import '../features/profile/edit_profile.dart';
import '../features/home/wellcome_screen.dart';
import '../features/profile/profile.dart';
import '../features/profile_setup/question_1_1.dart';
import 'routes_name.dart';

class AppRoute {
  static final List<GetPage> pages = [
    GetPage(
      name: RouteName.signup,
      page: () => SignupScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.signin,
      page: () => SignInScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.forgotPassword,
      page: () => ForgotPassword(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.verifyCode,
      page: () => VerifyCode(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.resetPassword,
      page: () => ResetPassword(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.accountCreatedSuccessfully,
      page: () => AccountCreatedSuccessfully(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.welcomeScreen,
      page: () => WelcomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.ageScreen,
      page: () => AgeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.nameScreen,
      page: () => NameScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.gender,
      page: () => GenderSelectionScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.language,
      page: () => LanguageSelectionScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.question1,
      page: () => Question_1(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.question11,
      page: () => Question11(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.grind,
      page: () => GrindLevel(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.upsellToPremium,
      page: () => UpsellToPremium(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.unlockAlpha,
      page: () => AlphaPlusScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.quoteSchedule,
      page: () => QuoteScheduleScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.dailyRoutines,
      page: () => DailyRoutines(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.subscription,
      page: () => SubscriptionScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.motivation,
      page: () => Motivation(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.motivation1,
      page: () => Motivation1(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // User Profile
    GetPage(
      name: RouteName.profile,
      page: () => ProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.editProfile,
      page: () => EditProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),



    // Leaderboard routes
    GetPage(
      name : RouteName.publicLeaderboard,
      page: () => PublicLeaderboardScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.selfLeaderboard,
      page: () => SelfLeaderboard(), // Assuming self leaderboard uses the same screen
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),


    // Other routes
    GetPage(
      name: RouteName.history,
      page: () => HistoryScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),

  ];
}
