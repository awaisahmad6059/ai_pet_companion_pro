enum QuestType { daily, weekly, achievement }
enum QuestStatus { active, completed, claimed }

class QuestEntity {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final QuestStatus status;
  final int target;
  int progress;
  final int xpReward;
  final int coinReward;
  final DateTime expiresAt;

  QuestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.status = QuestStatus.active,
    required this.target,
    this.progress = 0,
    this.xpReward = 50,
    this.coinReward = 25,
    DateTime? expiresAt,
  }) : expiresAt = expiresAt ??
            DateTime.now().add(const Duration(hours: 24));

  bool get isCompleted => progress >= target;
  double get progressFraction =>
      target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;

  QuestEntity copyWith({
    String? id,
    String? title,
    String? description,
    QuestType? type,
    QuestStatus? status,
    int? target,
    int? progress,
    int? xpReward,
    int? coinReward,
    DateTime? expiresAt,
  }) {
    return QuestEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
