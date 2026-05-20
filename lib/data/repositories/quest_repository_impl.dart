import 'package:ai_pet_companion_pro/data/datasources/local_datasource.dart';
import 'package:ai_pet_companion_pro/data/models/quest_model.dart';
import 'package:ai_pet_companion_pro/domain/entities/quest_entity.dart';
import 'package:ai_pet_companion_pro/domain/repositories/quest_repository.dart';
import 'package:uuid/uuid.dart';

class QuestRepositoryImpl implements QuestRepository {
  final LocalDataSource _localDataSource;
  List<QuestModel> _quests = [];

  QuestRepositoryImpl(this._localDataSource) {
    _loadQuests();
  }

  void _loadQuests() {
    final questJsonList = _localDataSource.loadQuests();
    if (questJsonList.isEmpty) {
      _generateDefaultQuests();
    } else {
      _quests = questJsonList
          .map((json) => QuestModel.fromJsonString(json))
          .toList();
    }
  }

  void _generateDefaultQuests() {
    const uuid = Uuid();
    _quests = [
      QuestModel(
        id: uuid.v4(),
        title: 'First Feeding',
        description: 'Feed your pet once',
        type: QuestType.daily,
        target: 1,
        xpReward: 50,
        coinReward: 25,
      ),
      QuestModel(
        id: uuid.v4(),
        title: 'Play Time',
        description: 'Play with your pet 3 times',
        type: QuestType.daily,
        target: 3,
        xpReward: 75,
        coinReward: 40,
      ),
      QuestModel(
        id: uuid.v4(),
        title: 'Pet Care',
        description: 'Clean your pet once',
        type: QuestType.daily,
        target: 1,
        xpReward: 50,
        coinReward: 20,
      ),
      QuestModel(
        id: uuid.v4(),
        title: 'Game Master',
        description: 'Play 2 mini-games',
        type: QuestType.daily,
        target: 2,
        xpReward: 100,
        coinReward: 60,
      ),
      QuestModel(
        id: uuid.v4(),
        title: 'Collector',
        description: 'Collect 50 coins',
        type: QuestType.daily,
        target: 50,
        xpReward: 80,
        coinReward: 30,
      ),
    ];
    _saveQuests();
  }

  Future<void> _saveQuests() async {
    final questJsonList =
        _quests.map((q) => q.toJsonString()).toList();
    await _localDataSource.saveQuests(questJsonList);
  }

  @override
  List<QuestEntity> getDailyQuests() => _quests;

  @override
  List<QuestEntity> getActiveQuests() =>
      _quests.where((q) => q.status == QuestStatus.active).toList();

  @override
  Future<void> updateQuestProgress(String questId, int amount) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) return;
    final quest = _quests[index];
    _quests[index] = QuestModel.fromEntity(quest.copyWith(
      progress: (quest.progress + amount).clamp(0, quest.target),
      status: quest.progress + amount >= quest.target
          ? QuestStatus.completed
          : QuestStatus.active,
    ));
    await _saveQuests();
  }

  @override
  Future<void> claimQuest(String questId) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) return;
    _quests[index] = QuestModel.fromEntity(
        _quests[index].copyWith(status: QuestStatus.claimed));
    await _saveQuests();
  }

  @override
  Future<void> generateDailyQuests() async {
    _generateDefaultQuests();
  }
}
