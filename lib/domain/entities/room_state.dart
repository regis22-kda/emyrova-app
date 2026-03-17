import 'package:equatable/equatable.dart';

/// Represents the current state of a room session
sealed class RoomState extends Equatable {
  const RoomState();

  /// Both partners have not submitted answers yet
  const factory RoomState.waitingForBoth() = WaitingForBoth;

  /// One partner has submitted, waiting for the other
  const factory RoomState.waitingForPartner({required String submittedAnswer}) =
      WaitingForPartner;

  /// Both partners have submitted - reveal answers
  const factory RoomState.revealed({
    required String partnerAAnswer,
    required String partnerBAnswer,
  }) = Revealed;

  @override
  List<Object?> get props => [];
}

/// Waiting for both partners to answer
class WaitingForBoth extends RoomState {
  const WaitingForBoth();

  @override
  List<Object?> get props => [];
}

/// Waiting for the second partner to answer
class WaitingForPartner extends RoomState {
  final String submittedAnswer;

  const WaitingForPartner({required this.submittedAnswer});

  @override
  List<Object?> get props => [submittedAnswer];
}

/// Both answers submitted - ready to reveal
class Revealed extends RoomState {
  final String partnerAAnswer;
  final String partnerBAnswer;

  const Revealed({
    required this.partnerAAnswer,
    required this.partnerBAnswer,
  });

  @override
  List<Object?> get props => [partnerAAnswer, partnerBAnswer];
}
