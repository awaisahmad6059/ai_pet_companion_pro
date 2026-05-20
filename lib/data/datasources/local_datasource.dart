import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_pet_companion_pro/data/models/player_model.dart';
import 'package:ai_pet_companion_pro/data/models/pet_model.dart';
import 'package:ai_pet_companion_pro/core/constants/app_constants.dart';
import 'package:ai_pet_companion_pro/core/error/exceptions.dart';

class LocalDataSource {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> savePlayer(PlayerModel player) async {
    try {
      final p = await prefs;
      await p.setString(AppConstants.storageKeyPlayer, player.toJsonString());
    } catch (e) {
      throw StorageException('Failed to save player: $e');
    }
  }

  PlayerModel? loadPlayer() {
    try {
      final jsonStr = _prefs?.getString(AppConstants.storageKeyPlayer);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      return PlayerModel.fromJsonString(jsonStr);
    } catch (e) {
      return null;
    }
  }

  Future<void> savePet(PetModel? pet) async {
    try {
      final p = await prefs;
      if (pet == null) {
        await p.remove(AppConstants.storageKeyPet);
      } else {
        await p.setString(AppConstants.storageKeyPet, pet.toJsonString());
      }
    } catch (e) {
      throw StorageException('Failed to save pet: $e');
    }
  }

  PetModel? loadPet() {
    try {
      final jsonStr = _prefs?.getString(AppConstants.storageKeyPet);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      return PetModel.fromJsonString(jsonStr);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveInventory(List<String> itemIds) async {
    try {
      final p = await prefs;
      await p.setString(AppConstants.storageKeyInventory, jsonEncode(itemIds));
    } catch (e) {
      throw StorageException('Failed to save inventory: $e');
    }
  }

  List<String> loadInventory() {
    try {
      final jsonStr = _prefs?.getString(AppConstants.storageKeyInventory);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      return (jsonDecode(jsonStr) as List<dynamic>).cast<String>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveQuests(List<String> questJsonList) async {
    try {
      final p = await prefs;
      await p.setString(AppConstants.storageKeyQuests, jsonEncode(questJsonList));
    } catch (e) {
      throw StorageException('Failed to save quests: $e');
    }
  }

  List<String> loadQuests() {
    try {
      final jsonStr = _prefs?.getString(AppConstants.storageKeyQuests);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      return (jsonDecode(jsonStr) as List<dynamic>).cast<String>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveThemeMode(bool isDark) async {
    final p = await prefs;
    await p.setBool(AppConstants.storageKeyTheme, isDark);
  }

  bool loadThemeMode() {
    return _prefs?.getBool(AppConstants.storageKeyTheme) ?? true;
  }

  Future<void> clearAll() async {
    final p = await prefs;
    await p.clear();
  }

  Future<void> init() async {
    await prefs;
  }

  Future<void> saveLastClaimTime(DateTime time) async {
    final p = await prefs;
    await p.setString(AppConstants.storageKeyLastClaimTime, time.toIso8601String());
  }

  Future<DateTime?> loadLastClaimTime() async {
    final p = await prefs;
    final str = p.getString(AppConstants.storageKeyLastClaimTime);
    if (str == null || str.isEmpty) return null;
    return DateTime.tryParse(str);
  }

  Future<void> clearLastClaimTime() async {
    final p = await prefs;
    await p.remove(AppConstants.storageKeyLastClaimTime);
  }
}
