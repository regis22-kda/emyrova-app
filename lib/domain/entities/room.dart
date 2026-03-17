import 'package:equatable/equatable.dart';
import 'room_state.dart';

/// Represents a room session for couple's gameplay
class Room extends Equatable {
  final String roomCode;
  final String partnerAUid;
  final String? partnerBUid;
  final String? partnerAAnswer;
  final String? partnerBAnswer;
  final RoomState state;

  const Room({
    required this.roomCode,
    required this.partnerAUid,
    this.partnerBUid,
    this.partnerAAnswer,
    this.partnerBAnswer,
    required this.state,
  });

  /// Checks if both partners are in the room
  bool get isFull => partnerBUid != null;

  /// Checks if both partners have submitted answers
  bool get bothAnswered => partnerAAnswer != null && partnerBAnswer != null;

  /// Gets the current user's answer based on whether they are partner A
  String? getCurrentUserAnswer(bool isPartnerA) {
    return isPartnerA ? partnerAAnswer : partnerBAnswer;
  }

  /// Gets the partner's answer based on whether the current user is partner A
  String? getPartnerAnswer(bool isPartnerA) {
    return isPartnerA ? partnerBAnswer : partnerAAnswer;
  }

  @override
  List<Object?> get props => [
        roomCode,
        partnerAUid,
        partnerBUid,
        partnerAAnswer,
        partnerBAnswer,
        state,
      ];
}
