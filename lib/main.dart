import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/authentication_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: Colors.deepPurple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStatePropertyAll<TextStyle>(
              TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            backgroundColor:
                const MaterialStatePropertyAll<Color>(Colors.indigo),
            shape: MaterialStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      home: StreamBuilder(
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            return const ChatScreen();
          }
          return const AuthenticationScreen();
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
