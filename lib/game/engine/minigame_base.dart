import 'dart:async';
import 'package:flutter/material.dart';

enum GameState { idle, playing, paused, gameOver }

abstract class MiniGameBase {
  String get gameName;
  IconData get gameIcon;
  GameState _state = GameState.idle;
  int _score = 0;
  int _highScore = 0;
  Duration _timeLimit = const Duration(seconds: 60);
  Timer? _gameTimer;

  GameState get state => _state;
  int get score => _score;
  int get highScore => _highScore;
  Duration get timeLimit => _timeLimit;

  set timeLimit(Duration limit) => _timeLimit = limit;

  void startGame() {
    _state = GameState.playing;
    _score = 0;
    onGameStart();
    _gameTimer = Timer(_timeLimit, () {
      endGame();
    });
  }

  void endGame() {
    _state = GameState.gameOver;
    _gameTimer?.cancel();
    if (_score > _highScore) {
      _highScore = _score;
    }
    onGameEnd();
  }

  void pauseGame() {
    _state = GameState.paused;
    _gameTimer?.cancel();
    onGamePause();
  }

  void resumeGame() {
    _state = GameState.playing;
    _gameTimer = Timer(_timeLimit, () => endGame());
    onGameResume();
  }

  void addScore(int points) {
    _score += points;
    onScoreChanged(_score);
  }

  void reset() {
    _state = GameState.idle;
    _score = 0;
    _gameTimer?.cancel();
    onReset();
  }

  int calculateCoinReward() {
    return (_score * 2) + (_score > 50 ? 25 : 0);
  }

  int calculateXpReward() {
    return (_score * 3) + (_score > 100 ? 50 : 0);
  }

  void onGameStart();
  void onGameEnd();
  void onGamePause();
  void onGameResume();
  void onScoreChanged(int newScore);
  void onReset();

  void dispose() {
    _gameTimer?.cancel();
  }
}
