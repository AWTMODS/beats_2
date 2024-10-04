import 'dart:async';
import 'package:beats_music/colors/text_style.dart';
import 'package:beats_music/screens/favorite_screen.dart';
import 'package:beats_music/screens/search_screen.dart';
import 'package:beats_music/screens/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:beats_music/controllers/player_controller.dart';
import 'package:beats_music/screens/drawer.dart';
import 'package:beats_music/screens/player.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlayerController controller =
  Get.find<PlayerController>(); // Accessing PlayerController with Get.find
  SongSortType sortType = SongSortType.DISPLAY_NAME;
  OrderType orderType = OrderType.ASC_OR_SMALLER;
  List<SongModel> allSongs = [];
  List<SongModel> filteredSongs = [];
  int albumCount = 0;
  int artistCount = 0;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final songs = await controller.audioQuery.querySongs(
      ignoreCase: true,
      orderType: orderType,
      sortType: sortType,
      uriType: UriType.EXTERNAL,
    );
    final albums = await controller.audioQuery.queryAlbums();
    final artists = await controller.audioQuery.queryArtists();

    setState(() {
      allSongs = songs;
      filteredSongs = songs;
      albumCount = albums.length;
      artistCount = artists.length;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Sort by Artist',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  filteredSongs.sort(
                          (a, b) => (a.artist ?? '').compareTo(b.artist ?? ''));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.white),
              title: const Text('Sort by Latest Added',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  filteredSongs
                      .sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage, color: Colors.white),
              title: const Text('Sort by Size',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  filteredSongs.sort((a, b) => b.size!.compareTo(a.size!));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha, color: Colors.white),
              title: const Text('Sort by Alphabetic Order',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  filteredSongs.sort((a, b) =>
                      a.displayNameWOExt.compareTo(b.displayNameWOExt));
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.black87,
      appBar: _selectedIndex == 0
          ? AppBar(
        backgroundColor: Colors.black26,
        title: const Text(
          'B e a t s',
          style: TextStyle(color: Colors.white, fontFamily: 'bold'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              _showSortOptions();
            },
          ),
        ],
      )
          : null,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildHomeContent(),
          SearchScreen(),
          FavoriteScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.black87,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Obx(() {
      final playing = controller.isPlaying.value;
      final playingSongIndex = controller.playIndex.value;

      return Column(
        children: [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBox('Songs', allSongs.length),
                _buildStatBox('Albums', albumCount),
                _buildStatBox('Artists', artistCount),
              ],
            ),
          ),
          Expanded(
            child: filteredSongs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredSongs.length,
                itemBuilder: (BuildContext context, int index) {
                  final song = filteredSongs[index];
                  final isPlaying =
                      playing && (index == playingSongIndex);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        song.displayNameWOExt,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isPlaying ? Colors.green : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        song.artist ?? "Unknown Artist",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          QueryArtworkWidget(
                            id: song.id,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.cover,
                            artworkBorder: BorderRadius.circular(8),
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      trailing: isPlaying
                          ? Image.asset(
                        'assets/animations/playing.gif',
                        height: 40,
                        width: 40,
                      )
                          : null,
                      onTap: () {
                        Get.to(
                              () => PlayerScreen(
                            data: filteredSongs,
                            index: index,
                          ),
                          transition: Transition.rightToLeft,
                        );
                        controller.playSong(
                            filteredSongs[index].uri, index);
                      },
                      onLongPress: () {
                        _showSongDetails(context, filteredSongs[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showSongDetails(BuildContext context, SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.circular(8),
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${song.displayNameWOExt}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Artist: ${song.artist}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Album: ${song.album}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Duration: ${Duration(milliseconds: song.duration ?? 0).toString().split('.').first.padLeft(8, "0")}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "File Path: ${song.data}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.playlist_add, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        _showToast(context, 'Added to playlist');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        Share.shareXFiles([XFile(song.data)], text: 'Check out this song!');
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        controller.deleteSong(song.id);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }



  Widget _buildStatBox(String label, int count) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}