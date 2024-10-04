import 'package:beats_music/screens/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:beats_music/colors/colors.dart';
import 'package:beats_music/colors/text_style.dart';
import 'package:beats_music/controllers/player_controller.dart';


class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Favorite Songs', style: OurStyle(color: Colors.white)),
        backgroundColor: bgDarkColor,
      ),
      body: Obx(
            () => ListView.builder(
          itemCount: controller.favoriteSongs.length,
          itemBuilder: (context, index) {
            var song = controller.favoriteSongs[index];
            return ListTile(
              leading: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                nullArtworkWidget: Icon(
                  Icons.music_note_rounded,
                  color: whiteColor,
                  size: 45,
                ),
              ),
              title: Text(song.displayNameWOExt, style: OurStyle(color: Colors.white)),
              subtitle: Text(song.artist ?? 'Unknown Artist', style: OurStyle(color: Colors.white70)),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.removeFavorite(song),
              ),
              onTap: () {
                var songIndex = controller.favoriteSongs.indexOf(song);
                controller.playSong(song.uri, songIndex);
                Get.to(PlayerScreen(index: songIndex, data: controller.favoriteSongs));
              },
            );
          },
        ),
      ),
    );
  }
}
