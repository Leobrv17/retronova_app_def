// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/friend_provider.dart';
import 'providers/ticket_provider.dart';
import 'providers/arcade_provider.dart';
import 'providers/score_provider.dart'; // AJOUTÉ
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FriendProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => ArcadeProvider()),
        ChangeNotifierProvider(create: (_) => ScoreProvider()), // AJOUTÉ
      ],
      child: const ArcadeApp(),
    ),
  );
}