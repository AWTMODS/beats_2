import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  var data = <SongModel>[].obs;

  MyAudioHandler() {
    // Listen to playback events and update playback state accordingly
    _player.playbackEventStream.listen((event) {
      playbackState.add(_transformEvent(event));
    });

    // Update the current media item when the index changes
    _player.currentIndexStream.listen((index) {
      if (index != null && data.isNotEmpty) {
        mediaItem.add(_convertToMediaItem(data[index]));
      }
    });

    // Update the media item's duration when it changes
    _player.durationStream.listen((duration) {
      final index = _player.currentIndex;
      if (index != null && data.isNotEmpty) {
        final newMediaItem = _convertToMediaItem(data[index]).copyWith(duration: duration);
        mediaItem.add(newMediaItem);
      }
    });
  }

  void setData(var newData) {
    data = newData;
  }

  @override
  Future<void> play() async {
    if (_player.audioSource == null && data.isNotEmpty) {
      // Set the audio source to the first item in the data if not already set
      await _player.setAudioSource(ConcatenatingAudioSource(
        children: data.map((song) {
          final uri = song.uri ?? ''; // Provide a default value if uri is null
          return AudioSource.uri(Uri.parse(uri));
        }).toList(),
      ));
    }
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < data.length) {
      await _player.seek(Duration.zero, index: index);
    }
  }

  MediaItem _convertToMediaItem(SongModel song) {
    return MediaItem(
      id: song.id.toString(),
      album: song.album ?? '',
      title: song.title,
      artist: song.artist,
      extras: {'uri': song.uri ?? ''}, // Provide a default value if uri is null
    );
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
        MediaAction.playPause,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
