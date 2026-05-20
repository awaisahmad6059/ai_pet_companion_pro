enum Personality { playful, lazy, grumpy, affectionate, independent }

enum PetMood { joyful, happy, neutral, sad, miserable }

class PetEntity {
  final String id;
  final String name;
  final Personality personality;
  double hunger;
  double happiness;
  double energy;
  double hygiene;
  bool isSleeping;
  final DateTime createdAt;
  DateTime lastUpdated;
  int affection;

  PetEntity({
    required this.id,
    required this.name,
    this.personality = Personality.playful,
    this.hunger = 80,
    this.happiness = 80,
    this.energy = 80,
    this.hygiene = 80,
    this.isSleeping = false,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.affection = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdated = lastUpdated ?? DateTime.now();

  PetMood get mood {
    final avg = (hunger + happiness + energy + hygiene) / 4;
    if (avg >= 80) return PetMood.joyful;
    if (avg >= 60) return PetMood.happy;
    if (avg >= 40) return PetMood.neutral;
    if (avg >= 20) return PetMood.sad;
    return PetMood.miserable;
  }

  double get overallHealth => (hunger + happiness + energy + hygiene) / 4;

  PetEntity copyWith({
    String? id,
    String? name,
    Personality? personality,
    double? hunger,
    double? happiness,
    double? energy,
    double? hygiene,
    bool? isSleeping,
    DateTime? lastUpdated,
    int? affection,
  }) {
    return PetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      hygiene: hygiene ?? this.hygiene,
      isSleeping: isSleeping ?? this.isSleeping,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
      affection: affection ?? this.affection,
    );
  }
}
