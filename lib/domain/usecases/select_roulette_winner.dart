import 'dart:math';
import '../entities/roulette_option.dart';

/// Use case for selecting a random roulette winner
class SelectRouletteWinner {
  final Random _random;

  SelectRouletteWinner({Random? random}) : _random = random ?? Random();

  RouletteOption call(List<RouletteOption> options) {
    if (options.isEmpty) {
      throw ArgumentError('Cannot select winner from empty options list');
    }

    final index = _random.nextInt(options.length);
    return options[index];
  }
}
