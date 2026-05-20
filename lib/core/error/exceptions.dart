class GameException implements Exception {
  final String message;
  final String? code;
  GameException(this.message, {this.code});

  @override
  String toString() => 'GameException($code): $message';
}

class StorageException extends GameException {
  StorageException(String message) : super(message, code: 'STORAGE_ERROR');
}

class PetNotFoundException extends GameException {
  PetNotFoundException() : super('Pet not found', code: 'PET_NOT_FOUND');
}

class InsufficientCoinsException extends GameException {
  InsufficientCoinsException()
      : super('Insufficient coins', code: 'INSUFFICIENT_COINS');
}

class ItemNotFoundException extends GameException {
  ItemNotFoundException() : super('Item not found', code: 'ITEM_NOT_FOUND');
}

class InvalidStatException extends GameException {
  InvalidStatException(String stat)
      : super('Invalid stat: $stat', code: 'INVALID_STAT');
}

class QuestNotFoundException extends GameException {
  QuestNotFoundException() : super('Quest not found', code: 'QUEST_NOT_FOUND');
}
