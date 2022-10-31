import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ritter_microblog/new_post_screen.dart';
import 'package:ritter_microblog/settings_screen.dart';
import 'package:ritter_microblog/themes.dart';

import 'firebase_options.dart';
import 'auth_screens/auth_screens.dart';
import 'home_screens/home_screen.dart';

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
    if (auth.currentUser == null) {
      return '/signin';
    }
    if (!auth.currentUser!.emailVerified && auth.currentUser!.email != null) {
      return '/verify-email';
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
        '/signin': buildSignInScreen,
        '/verify-email': buildEmailVerificationScreen,
        '/forgot-password': buildForgotPasswordScreen,
        '/home': (context) => const MyHomeScreen(),
        '/new-post': (context) => const MyNewPostScreen(),
        '/settings': (context) => const MySettingsScreen()
      },
    );
  }
}
