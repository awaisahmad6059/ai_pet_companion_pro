class AppConstants {
  AppConstants._();

  static const String appName = 'AI Pet Companion Pro';
  static const String version = '1.0.0';

  static const int maxPetStats = 100;
  static const int minPetStats = 0;
  static const int maxLevel = 100;

  static const int baseXPPerLevel = 100;
  static const double xpMultiplier = 1.5;

  static const int startingCoins = 500;
  static const int maxEnergy = 100;

  static const int statDecayIntervalMinutes = 5;
  static const int statDecayAmount = 2;

  static const String storageKeyPlayer = 'player_data';
  static const String storageKeyPet = 'pet_data';
  static const String storageKeyInventory = 'inventory_data';
  static const String storageKeyQuests = 'quests_data';
  static const String storageKeyTheme = 'theme_mode';
  static const String storageKeyLastClaimTime = 'last_claim_time';
  static const Duration claimCooldown = Duration(hours: 24);
  static const int dailyRewardCoins = 25;
  
}
