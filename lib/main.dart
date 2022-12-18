import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ritter_microblog/auth_screens/signup_screen.dart';
import 'package:ritter_microblog/screens/edit_profile_screen.dart';

import 'auth_screens/signin_screen.dart';
import 'auth_screens/verify_email_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/new_post_screen.dart';
import 'screens/settings_screen.dart';
import 'themes.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String get initialRoute {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null || !auth.currentUser!.emailVerified) {
      return '/signin';
    }
    return '/home';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ritter Microblog',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      routes: {
        '/signin': (context) => const MySigninScreen(),
        '/signup': (context) => const MySignupScreen(),
        '/verify-email': (context) => const MyVerifyEmailScreen(),
        // '/forgot-password': buildForgotPasswordScreen,
        '/home': (context) => const MyHomeScreen(),
        '/new-post': (context) => const MyNewPostScreen(),
        '/settings': (context) => const MySettingsScreen(),
        '/edit-profile': (context) => const MyEditProfileScreen(),
      },
    );
  }
}
