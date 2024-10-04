import 'package:beats_music/colors/colors.dart';
import 'package:beats_music/colors/text_style.dart';
import 'package:beats_music/controllers/player_controller.dart';
import 'package:beats_music/screens/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatelessWidget {
  final List<SongModel> data;
  final int index;

  const PlayerScreen({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    // Initialize the player with the selected song
    controller.playSong(data[index].uri, index);

    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        title: Text('Now Playing', style: OurStyle(color: Colors.white)),
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showSongDetails(context, data[controller.playIndex.value]);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
                  () => Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                  ),
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(
                    id: data[controller.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    artworkQuality: FilterQuality.high, // High resolution image
                    artworkFit: BoxFit.cover,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(
                      Icons.music_note_rounded,
                      size: 45,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Obx(
                      () => Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        controller.playIndex.value < data.length
                            ? data[controller.playIndex.value].displayNameWOExt
                            : 'Unknown Song',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: OurStyle(
                          color: bgDarkColor,
                          family: bold,
                          size: 29,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data[controller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: OurStyle(
                          color: bgDarkColor,
                          family: regular,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                            () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: OurStyle(color: bgDarkColor),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Slider(
                                thumbColor: buttonColor,
                                inactiveColor: bgColor,
                                activeColor: bgDarkColor,
                                value: controller.value.value,
                                max: controller.max.value,
                                onChanged: (newValue) {
                                  controller.changeDurationToSeconds(newValue.toInt());
                                },
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: OurStyle(color: bgDarkColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shuffle_rounded,
                              color: bgDarkColor,
                              size: 30,
                            ),
                            onPressed: controller.shufflePlaylist,
                          ),
                          IconButton(
                            icon: Icon(
                              controller.repeatMode.value == RepeatMode.off
                                  ? Icons.repeat
                                  : controller.repeatMode.value == RepeatMode.all
                                  ? Icons.repeat_on_rounded
                                  : Icons.repeat_one_rounded,
                              color: bgDarkColor,
                              size: 30,
                            ),
                            onPressed: controller.toggleRepeat,
                          ),
                          Obx(
                                () => IconButton(
                              icon: Icon(
                                controller.isFavorite.value
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: controller.isFavorite.value
                                    ? Colors.green
                                    : bgDarkColor,
                                size: 30,
                              ),
                              onPressed: controller.toggleFavorite,
                            ),
                          ),
                          Obx(
                                () => IconButton(
                              icon: Stack(
                                children: [
                                  const Icon(
                                    Icons.speed_rounded,
                                    color: bgDarkColor,
                                    size: 30,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Text(
                                      controller.playbackSpeed.value.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: bgDarkColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: controller.changePlaybackSpeed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              color: bgDarkColor,
                              size: 40,
                            ),
                            onPressed: () {
                              controller.playPrevious();
                            },
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: bgDarkColor,
                            child: Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                onPressed: () {
                                  controller.togglePlayPause();
                                },
                                icon:
                                controller.isPlaying.value
                                    ? const Icon(Icons.pause, color: whiteColor)
                                    : const Icon(Icons.play_arrow_rounded, color: whiteColor),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: bgDarkColor,
                              size: 40,
                            ),
                            onPressed: () {
                              controller.playNext();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSongDetails(BuildContext context, SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgDarkColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Song Details',
                    style: OurStyle(color: Colors.white, family: bold, size: 20),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.white),
                  title: Text('Title', style: OurStyle(color: Colors.grey)),
                  subtitle: Text(song.displayNameWOExt, style: OurStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: Text('Artist', style: OurStyle(color: Colors.grey)),
                  subtitle: Text(song.artist ?? 'Unknown', style: OurStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: const Icon(Icons.folder, color: Colors.white),
                  title: Text('Path ${song.data}', style: OurStyle(color: Colors.grey)),

                ),
                ListTile(
                  leading: const Icon(Icons.timer, color: Colors.white),
                  title: Text('Duration', style: OurStyle(color: Colors.grey)),
                  subtitle: Text(formatDuration(song.duration), style: OurStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: const Icon(Icons.file_download, color: Colors.white),
                  title: Text('Size', style: OurStyle(color: Colors.grey)),
                  subtitle: Text('${(song.size / (1024 * 1024)).toStringAsFixed(2)} MB', style: OurStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDuration(int? duration) {
    if (duration == null) return 'Unknown';
    int minutes = (duration / 60000).floor();
    int seconds = ((duration % 60000) / 1000).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
