import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/room.dart';
import '../../domain/entities/room_state.dart';

/// Data model for Room - used for Firestore serialization
class RoomModel extends Equatable {
  final String roomCode;
  final String partnerAUid;
  final String? partnerBUid;
  final String? partnerAAnswer;
  final String? partnerBAnswer;

  const RoomModel({
    required this.roomCode,
    required this.partnerAUid,
    this.partnerBUid,
    this.partnerAAnswer,
    this.partnerBAnswer,
  });

  /// Creates a RoomModel from a Firestore document snapshot
  factory RoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final answers = data['answers'] as Map<String, dynamic>?;

    return RoomModel(
      roomCode: data['room_code'] as String? ?? doc.id,
      partnerAUid: data['partner_a_uid'] as String,
      partnerBUid: data['partner_b_uid'] as String?,
      partnerAAnswer: answers?['partner_a'] as String?,
      partnerBAnswer: answers?['partner_b'] as String?,
    );
  }

  /// Converts to domain Room entity with computed state
  Room toEntity() {
    final roomState = _computeRoomState();

    return Room(
      roomCode: roomCode,
      partnerAUid: partnerAUid,
      partnerBUid: partnerBUid,
      partnerAAnswer: partnerAAnswer,
      partnerBAnswer: partnerBAnswer,
      state: roomState,
    );
  }

  /// Computes the current room state based on answer status
  RoomState _computeRoomState() {
    // Both answers submitted - reveal
    if (partnerAAnswer != null && partnerBAnswer != null) {
      return Revealed(
        partnerAAnswer: partnerAAnswer!,
        partnerBAnswer: partnerBAnswer!,
      );
    }

    // Exactly one answer submitted - waiting for partner
    if (partnerAAnswer != null) {
      return WaitingForPartner(submittedAnswer: partnerAAnswer!);
    }

    if (partnerBAnswer != null) {
      return WaitingForPartner(submittedAnswer: partnerBAnswer!);
    }

    // No answers yet - waiting for both
    return const WaitingForBoth();
  }

  /// Converts to Firestore map for writing
  Map<String, dynamic> toFirestore() {
    return {
      'room_code': roomCode,
      'partner_a_uid': partnerAUid,
      'partner_b_uid': partnerBUid,
      if (partnerAAnswer != null || partnerBAnswer != null)
        'answers': {
          if (partnerAAnswer != null) 'partner_a': partnerAAnswer,
          if (partnerBAnswer != null) 'partner_b': partnerBAnswer,
        },
    };
  }

  /// Creates a copy with updated fields
  RoomModel copyWith({
    String? roomCode,
    String? partnerAUid,
    String? partnerBUid,
    String? partnerAAnswer,
    String? partnerBAnswer,
  }) {
    return RoomModel(
      roomCode: roomCode ?? this.roomCode,
      partnerAUid: partnerAUid ?? this.partnerAUid,
      partnerBUid: partnerBUid ?? this.partnerBUid,
      partnerAAnswer: partnerAAnswer ?? this.partnerAAnswer,
      partnerBAnswer: partnerBAnswer ?? this.partnerBAnswer,
    );
  }

  @override
  List<Object?> get props => [
        roomCode,
        partnerAUid,
        partnerBUid,
        partnerAAnswer,
        partnerBAnswer,
      ];
}
