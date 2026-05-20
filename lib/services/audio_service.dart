import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._();
  factory AudioService() => _instance;
  AudioService._();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isMuted = false;
  double _volume = 0.5;

  bool get isMuted => _isMuted;
  double get volume => _volume;

  Future<void> init() async {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    _bgmPlayer.setVolume(_volume);
  }

  Future<void> playBgm(String path) async {
    if (_isMuted) return;
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.play(AssetSource(path.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint('BGM play error: $e');
    }
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  Future<void> playSfx(String path) async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.play(AssetSource(path.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint('SFX play error: $e');
    }
  }

  Future<void> playClick() async {
    await playSfx('audio/click.wav');
  }

  Future<void> playCoin() async {
    await playSfx('audio/coin.wav');
  }

  Future<void> playLevelUp() async {
    await playSfx('audio/level_up.wav');
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    _bgmPlayer.setVolume(_volume);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _bgmPlayer.setVolume(0);
    } else {
      _bgmPlayer.setVolume(_volume);
    }
  }

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
