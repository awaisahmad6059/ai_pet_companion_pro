import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/data/repositories/quest_repository_impl.dart';
import 'package:ai_pet_companion_pro/domain/entities/quest_entity.dart';
import 'package:ai_pet_companion_pro/domain/repositories/quest_repository.dart';
import 'package:ai_pet_companion_pro/presentation/providers/theme_provider.dart';

export 'package:ai_pet_companion_pro/domain/entities/quest_entity.dart';

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return QuestRepositoryImpl(dataSource);
});

final questsProvider = Provider<List<QuestEntity>>((ref) {
  final repo = ref.watch(questRepositoryProvider);
  return repo.getDailyQuests();
});

final activeQuestsProvider = Provider<List<QuestEntity>>((ref) {
  final repo = ref.watch(questRepositoryProvider);
  return repo.getActiveQuests();
});

final questUpdateProvider = FutureProvider.family<void, QuestUpdateParams>(
    (ref, params) async {
  final repo = ref.watch(questRepositoryProvider);
  await repo.updateQuestProgress(params.questId, params.amount);
});

class QuestUpdateParams {
  final String questId;
  final int amount;
  QuestUpdateParams({required this.questId, required this.amount});
}
