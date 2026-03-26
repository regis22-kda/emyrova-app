import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing player name settings
class PlayerSettingsService {
  static const String _player1Key = 'player1_name';
  static const String _player2Key = 'player2_name';
  static const String _defaultPlayer1 = 'Player 1';
  static const String _defaultPlayer2 = 'Player 2';

  /// Get saved player names from SharedPreferences
  Future<Map<String, String>> getPlayerNames() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'player1': prefs.getString(_player1Key) ?? _defaultPlayer1,
      'player2': prefs.getString(_player2Key) ?? _defaultPlayer2,
    };
  }

  /// Save player names to SharedPreferences
  Future<void> savePlayerNames(String player1, String player2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_player1Key, player1.trim().isEmpty ? _defaultPlayer1 : player1.trim());
    await prefs.setString(_player2Key, player2.trim().isEmpty ? _defaultPlayer2 : player2.trim());
  }

  /// Reset player names to defaults
  Future<void> resetPlayerNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_player1Key);
    await prefs.remove(_player2Key);
  }

  /// Get default player 1 name
  String getDefaultPlayer1Name() => _defaultPlayer1;

  /// Get default player 2 name
  String getDefaultPlayer2Name() => _defaultPlayer2;
}
