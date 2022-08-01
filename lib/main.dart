import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF282E3D),
        body: Stack(
          children: [
            const Align(
              alignment: Alignment(0, -0.8),
              child: Text(
                'Test your\nreaction speed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: const Color(0xFF6D6D6D),
                child: SizedBox(
                  height: 160,
                  width: 300,
                  child: Center(
                    child: Text(
                      millisecondsText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.9),
              child: GestureDetector(
                onTap: () => setState(() => setState(() {
                      switch (gameState) {
                        case GameState.readyToStart:
                          gameState = GameState.waiting;
                          millisecondsText = "";
                          _startWaitingTimer();
                          break;
                        case GameState.waiting:
                          break;
                        case GameState.canBeStop:
                          gameState = GameState.readyToStart;
                          stoppableTimer?.cancel();
                          break;
                      }
                    })),
                child: ColoredBox(
                  color: _getButtonColor(),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Text(
                        _getButtonText(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStop:
        return "STOP";
    }
  }

  _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return Color(0xFF40CA88);
      case GameState.waiting:
        return Color(0xFFE0982D);
      case GameState.canBeStop:
        return Color(0xFFE02D47);
      default:
        return Color(0xFF40CA88);
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStop;
      });
    });
    _stsrtStoppableTimer();
  }

  void _stsrtStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = '${timer.tick * 16} ms';
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStop }
