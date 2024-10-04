import 'dart:async';
import 'dart:io';
import 'package:beats_music/controllers/audio_background_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

enum RepeatMode { off, all, one }

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  final audioHandler = Get.put(MyAudioHandler());
  var data = <SongModel>[].obs;
  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  var repeatMode = RepeatMode.off.obs;
  var playbackSpeed = 1.0.obs;

  var songs = <SongModel>[].obs;
  var favoriteSongs = <SongModel>[].obs;
  var isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
    updatePosition();
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      if (d != null) {
        duration.value = d.toString().split(".")[0];
        max.value = d.inSeconds.toDouble();
      }
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  void changeDurationToSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  Future<void> playSong(String? uri, int index) async {
    if (uri != null) {
      playIndex.value = index;
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      await audioPlayer.play();
      isPlaying.value = true;
      isFavorite.value = favoriteSongs.contains(songs[playIndex.value]);
      print("Playing song at index: $index, URI: $uri");
    }
  }

  void checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
      await loadSongs();
    } else {
      checkPermission();
    }
  }

  Future<void> loadSongs() async {
    songs.value = await audioQuery.querySongs();
  }

  Future<void> searchSongs(String query) async {
    List<SongModel> allSongs = await audioQuery.querySongs();
    final filteredSongs = allSongs
        .where((song) => song.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    songs.value = filteredSongs;
  }

  Future<void> shufflePlaylist() async {
    songs.shuffle();
  }

  void toggleRepeat() {
    switch (repeatMode.value) {
      case RepeatMode.off:
        repeatMode.value = RepeatMode.all;
        audioPlayer.setLoopMode(LoopMode.all);
        break;
      case RepeatMode.all:
        repeatMode.value = RepeatMode.one;
        audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatMode.one:
        repeatMode.value = RepeatMode.off;
        audioPlayer.setLoopMode(LoopMode.off);
        break;
    }
  }

  void addSongToFavorites(SongModel song) {
    // Your logic to add the song to favorites
  }

  void toggleFavorite() {
    var currentSong = songs[playIndex.value];
    if (isFavorite.value) {
      favoriteSongs.remove(currentSong);
    } else {
      favoriteSongs.add(currentSong);
    }
    isFavorite.toggle();
  }

  void removeFavorite(SongModel song) {
    favoriteSongs.remove(song);
    if (songs[playIndex.value].uri == song.uri) {
      isFavorite.value = false;
    }
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  Future<void> playPrevious() async {
    if (songs.isNotEmpty) {
      int newIndex = playIndex.value - 1;
      if (newIndex < 0) {
        newIndex = songs.length - 1; // Loop to the last song if at the beginning
      }
      playSong(songs[newIndex].uri, newIndex);
    }
  }

  Future<void> playNext() async {
    if (songs.isNotEmpty) {
      int newIndex = playIndex.value + 1;
      if (newIndex >= songs.length) {
        newIndex = 0; // Loop to the first song if at the end
      }
      playSong(songs[newIndex].uri, newIndex);
    }
  }

  void updateSliderPosition() {
    // Implement updating slider position logic here
  }

  void togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
      isPlaying.value = false;
    } else {
      audioPlayer.play();
      isPlaying.value = true;
    }
  }

  void changePlaybackSpeed() {
    playbackSpeed.value += 0.5;
    if (playbackSpeed.value > 2.0) {
      playbackSpeed.value = 0.5;
    }
    audioPlayer.setSpeed(playbackSpeed.value);
  }

  void stop() {
    audioPlayer.stop();
    isPlaying.value = false;
    playIndex.value = -1;
  }

  Future<void> deleteSong(int songId) async {
    try {
      final song = songs.firstWhere((song) => song.id == songId);
      final file = File(song.data);
      await file.delete();
      songs.remove(song);
      Get.snackbar(
        'Delete Song',
        'Song deleted successfully',
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete song',
        colorText: Colors.white,
      );
    }
  }
}
