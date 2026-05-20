import 'package:ai_pet_companion_pro/domain/entities/quest_entity.dart';

abstract class QuestRepository {
  List<QuestEntity> getDailyQuests();
  List<QuestEntity> getActiveQuests();
  Future<void> updateQuestProgress(String questId, int amount);
  Future<void> claimQuest(String questId);
  Future<void> generateDailyQuests();
}
