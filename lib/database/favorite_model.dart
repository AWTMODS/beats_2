import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteModel extends ChangeNotifier {
  List<SongModel> _favorites = [];

  List<SongModel> get favorites => _favorites;

  void addFavorite(SongModel song) {
    _favorites.add(song);
    notifyListeners();
  }

  void removeFavorite(SongModel song) {
    _favorites.remove(song);
    notifyListeners();
  }
}
