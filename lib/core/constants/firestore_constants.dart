/// Constants for Firestore collection names and field names
class FirestoreConstants {
  const FirestoreConstants._();

  /// Collection names
  static const String questionsCollection = 'questions';
  static const String roomsCollection = 'rooms';
  static const String rouletteOptionsCollection = 'roulette_options';

  /// Field names for questions
  static const String fieldIsActive = 'is_active';
  static const String fieldCategory = 'category';
  static const String fieldPrompt = 'prompt';
  static const String fieldType = 'type';
  static const String fieldFollowup = 'followup';
  static const String fieldFollowupLogic = 'followup_logic';
  static const String fieldFollowupOnComplete = 'on_complete';

  /// Field names for rooms
  static const String fieldRoomCode = 'room_code';
  static const String fieldPartnerAUid = 'partner_a_uid';
  static const String fieldPartnerBUid = 'partner_b_uid';
  static const String fieldAnswers = 'answers';
  static const String fieldPartnerAAnswer = 'partner_a';
  static const String fieldPartnerBAnswer = 'partner_b';
}
