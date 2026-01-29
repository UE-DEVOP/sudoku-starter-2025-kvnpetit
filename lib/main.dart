import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_starter/home.dart';
import 'package:sudoku_starter/game.dart';
import 'package:sudoku_starter/end.dart';
import 'package:sudoku_starter/defeat.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const Game(title: 'Sudoku'),
    ),
    GoRoute(
      path: '/end',
      builder: (context, state) => const End(),
    ),
    GoRoute(
      path: '/defeat',
      builder: (context, state) => const Defeat(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
